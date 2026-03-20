import SwiftUI
import Speech
import AVFoundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

class SMAIVoiceViewModel: NSObject, ObservableObject, SFSpeechRecognizerDelegate, AVSpeechSynthesizerDelegate {
    @Published var messages: [ChatMessage] = []
    @Published var isListening = false
    @Published var pulseScale: CGFloat = 1.0
    
    // Live transcription text
    @Published var transcribedText: String = ""
    
    // Control when to show the vitals form
    @Published var showVitalsForm = false
    
    // Trigger navigation to the next screen
    @Published var navigateToNext = false
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let synthesizer = AVSpeechSynthesizer()
    private var autoSendWorkItem: DispatchWorkItem?
    
    enum ChatState {
        case initialGreeting
        case waitingForName
        case waitingForVitals
        case finished
    }
    @Published var currentState: ChatState = .initialGreeting
    
    override init() {
        super.init()
        speechRecognizer.delegate = self
        synthesizer.delegate = self
        setupAudioSession()
    }
    
    func startInitialGreeting() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.currentState = .waitingForName
            self.speak("I am S.M.A.I., your stress management assistant, how may I address you?")
        }
    }
    
    func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if self.messages.isEmpty {
                        self.startInitialGreeting()
                    }
                }
            }
        }
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .videoChat, options: [.defaultToSpeaker, .allowBluetooth, .mixWithOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup failed: \\(error)")
        }
    }
    
    func toggleListening() {
        if isListening {
            stopListening()
        } else {
            startListening()
        }
    }
    
    private func startListening() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.requiresOnDeviceRecognition = false // Use Apple's servers if offline isn't available
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        // Reset transcribed text when starting to listen
        DispatchQueue.main.async {
            if self.transcribedText.isEmpty || self.transcribedText.hasPrefix("Error:") {
                self.transcribedText = ""
            }
        }
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                isFinal = result.isFinal
                DispatchQueue.main.async {
                    self.transcribedText = result.bestTranscription.formattedString
                    
                    self.autoSendWorkItem?.cancel()
                    let workItem = DispatchWorkItem { [weak self] in
                        self?.sendManualMessage()
                    }
                    self.autoSendWorkItem = workItem
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: workItem)
                }
            }
            
            if let error = error {
                print("Speech recognition error: \\(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.transcribedText = "Error: \\(error.localizedDescription) (Note: Simulator dictation is often flaky, try restarting the Simulator)"
                }
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                DispatchQueue.main.async {
                    self.isListening = false
                }
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            DispatchQueue.main.async {
                self.isListening = true
                self.startPulseAnimation()
            }
        } catch {
            print("audioEngine couldn't start because of an error.")
            DispatchQueue.main.async {
                self.transcribedText = "Error: Audio engine failed to start."
                self.isListening = false
            }
        }
    }
    
    // MARK: - SFSpeechRecognizerDelegate
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            DispatchQueue.main.async {
                self.transcribedText = "Dictation not available on this device/simulator."
                self.stopListening()
            }
        }
    }
    
    func stopListening() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        DispatchQueue.main.async {
            self.isListening = false
        }
    }
    
    func sendManualMessage() {
        autoSendWorkItem?.cancel()
        let text = transcribedText.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty { return }
        
        // Stop listening if sending
        if isListening {
            stopListening()
        }
        
        // Add to chat history
        DispatchQueue.main.async {
            self.messages.append(ChatMessage(text: text, isUser: true))
            self.transcribedText = ""
            self.handleSMALogic(userText: text)
        }
    }
    
    func handleSMALogic(userText: String) {
        let text = userText.lowercased()
        
        if text.contains("stop") || text.contains("quit") {
            speak("Thank you for using S.M.A.I..")
            currentState = .finished
            return
        }
        
        switch currentState {
        case .initialGreeting, .waitingForName:
            // Extract the name robustly (remove "i am", "my name is", etc.)
            var name = text
            let prefixes = ["i'm ", "i am ", "my name is ", "im ", "this is "]
            for prefix in prefixes {
                if let range = text.range(of: prefix) {
                    name = String(text[range.upperBound...])
                    break
                }
            }
            name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // If the name is weirdly long, it might be a bad transcript; just take the first word.
            if name.components(separatedBy: .whitespaces).count > 2 {
                name = name.components(separatedBy: .whitespaces).first ?? name
            }
            
            let capitalizedName = name.capitalized
            currentState = .waitingForVitals
            speak("Nice to meet you, \(capitalizedName). Please enter your vital indicators below if you know them, or say them out loud.")
            
        case .waitingForVitals:
            speak("Got it. Our next step is a quick symptom check-up. Please say 'Continue' or tap the Continue Analysis button to proceed.")
            currentState = .finished
            
        case .finished:
            if text.contains("continue") || text.contains("next") || text.contains("yes") || text.contains("ready") || text.contains("analysis") {
                DispatchQueue.main.async {
                    self.navigateToNext = true
                }
            } else {
                speak("I am ready when you are. Just say 'Continue' to move to the symptom check-up.")
            }
        }
    }
    
    func speak(_ text: String) {
        let msg = ChatMessage(text: text, isUser: false)
        DispatchQueue.main.async { self.messages.append(msg) }
        
        if isListening { stopListening() }
        if synthesizer.isSpeaking { synthesizer.stopSpeaking(at: .immediate) }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch { }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        if let voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact") {
            utterance.voice = voice
        }
        utterance.rate = 0.50
        utterance.pitchMultiplier = 1.0
        
        synthesizer.speak(utterance)
        startPulseAnimation()
    }
    
    func startPulseAnimation() {
        withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            self.pulseScale = 1.2
        }
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            if !self.isListening {
                withAnimation { self.pulseScale = 1.0 }
            }
            
            // Auto-progress based on state
            if self.currentState == .waitingForName {
                self.startListening()
            } else if self.currentState == .waitingForVitals {
                withAnimation {
                    self.showVitalsForm = true
                }
            }
        }
    }
}

// Helper extension for hex colors matching Tailwind
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
