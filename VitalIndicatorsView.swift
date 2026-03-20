import SwiftUI

struct VitalIndicatorsView: View {
    @EnvironmentObject var router: StitchRouter
    @StateObject private var viewModel = SMAIVoiceViewModel()
    @EnvironmentObject var assessment: AssessmentData
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#131022"),
                    Color(hex: "#1a1635"),
                    Color(hex: "#131022")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Top Orb Area
                VStack(spacing: 24) {
                    ZStack {
                        // Outer Glow Orb
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#3713ec").opacity(0.8), Color.pink.opacity(0.8)]), startPoint: .topTrailing, endPoint: .bottomLeading))
                            .frame(width: 120, height: 120)
                            .shadow(color: Color(hex: "#3713ec").opacity(0.4), radius: 40, x: 0, y: 0)
                            .shadow(color: Color.pink.opacity(0.2), radius: 80, x: 0, y: 0)
                            .scaleEffect(viewModel.pulseScale)
                        
                        // Inner Glass Card
                        Circle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 100, height: 100)
                            .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                            .backdropBlur(radius: 12)
                        
                        if let uiImage = UIImage(named: "smai_logo_pink_blue") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 36))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 4) {
                        Text("S.M.A.I.")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.white)
                        
                        Text(viewModel.isListening ? "Listening for your health data..." : "Ready")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#94a3b8")) // slate-400
                    }
                }
                .padding(.bottom, 24)
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 24) {
                            ForEach(viewModel.messages) { msg in
                                ChatBubble(message: msg)
                                    .id(msg.id)
                            }
                            
                            if viewModel.showVitalsForm {
                                // Vital Indicators Card
                                VStack(spacing: 16) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "waveform.path.ecg")
                                            .foregroundColor(Color(hex: "#3713ec"))
                                        Text("Vital Indicators")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    
                                    HStack(spacing: 16) {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("Blood Sugar")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(Color(hex: "#94a3b8"))
                                            TextField("mg/dL", text: $assessment.bloodSugar)
                                                .padding(10)
                                                .background(Color.white.opacity(0.05))
                                                .cornerRadius(8)
                                                .foregroundColor(.white)
                                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.1), lineWidth: 1))
                                                .keyboardType(.numbersAndPunctuation)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("Blood Pressure")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(Color(hex: "#94a3b8"))
                                            TextField("120/80", text: $assessment.bloodPressure)
                                                .padding(10)
                                                .background(Color.white.opacity(0.05))
                                                .cornerRadius(8)
                                                .foregroundColor(.white)
                                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.1), lineWidth: 1))
                                                .keyboardType(.numbersAndPunctuation)
                                        }
                                    }
                                    
                                    Text("Don't worry if you don't have these measurements right now.")
                                        .font(.system(size: 11))
                                        .italic()
                                        .foregroundColor(Color(hex: "#64748b"))
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 8)
                                    
                                    Button(action: {
                                        router.navigate(to: .symptomCheckup)
                                    }) {
                                        Text("Continue Analysis")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color(hex: "#3713ec"))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(Color(hex: "#3713ec").opacity(0.2))
                                            .cornerRadius(8)
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#3713ec").opacity(0.4), lineWidth: 1))
                                    }
                                }
                                .padding(20)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                            }
                            
                            Color.clear.frame(height: 1).id("BOTTOM")
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 280) // Space for bottom nav and input
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        withAnimation {
                            proxy.scrollTo("BOTTOM", anchor: .bottom)
                        }
                    }
                    .onChange(of: viewModel.showVitalsForm) { show in
                        if show {
                            withAnimation(.easeInOut.delay(0.2)) {
                                proxy.scrollTo("BOTTOM", anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: viewModel.navigateToNext) { navigate in
                        if navigate {
                            router.navigate(to: .symptomCheckup)
                        }
                    }
                }
            }
            
            // Bottom Floating Input & Nav
            VStack(spacing: 0) {
                Spacer()
                
                // Text Input Fallback / Send Button
                HStack(spacing: 12) {
                    TextField("Speak or type response...", text: $viewModel.transcribedText)
                        .padding(14)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.2), lineWidth: 1))
                        .onSubmit {
                            viewModel.sendManualMessage()
                        }
                    
                    Button(action: {
                        viewModel.sendManualMessage()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(14)
                            .background(viewModel.transcribedText.isEmpty ? Color(hex: "#475569") : Color(hex: "#3713ec")) // Highlight when active
                            .clipShape(Circle())
                            .shadow(color: viewModel.transcribedText.isEmpty ? Color.clear : Color(hex: "#3713ec").opacity(0.4), radius: 5, x: 0, y: 0)
                    }
                    .disabled(viewModel.transcribedText.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                // Bottom Toolbar / Mic setup
                ZStack(alignment: .bottom) {
                    HStack { Spacer() }
                        .frame(height: 80)
                        .background(Color(hex: "#131022").opacity(0.8))
                        .backdropBlur(radius: 20)
                        .overlay(Rectangle().frame(height: 1).foregroundColor(Color.white.opacity(0.1)), alignment: .top)
                    
                    HStack {
                        Button(action: {
                            router.navigate(to: .welcome)
                        }) {
                            NavIcon(icon: "message.fill", text: "CHAT", isActive: true)
                        }
                        Spacer()
                        NavIcon(icon: "chart.xyaxis.line", text: "TRENDS", isActive: false)
                        Spacer().frame(width: 80) // Mic space
                        NavIcon(icon: "heart.fill", text: "HEALTH", isActive: false)
                        Spacer()
                        NavIcon(icon: "person.fill", text: "PROFILE", isActive: false)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    
                    // Center Mic Button Focus
                    Button(action: {
                        viewModel.toggleListening()
                    }) {
                        ZStack {
                            Circle()
                                .fill(viewModel.isListening ? Color.red : Color(hex: "#3713ec"))
                                .frame(width: 64, height: 64)
                                .shadow(color: (viewModel.isListening ? Color.red : Color(hex: "#3713ec")).opacity(0.4), radius: 20, x: 0, y: 0)
                            
                            Image(systemName: viewModel.isListening ? "stop.fill" : "mic.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    }
                    .offset(y: -40)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            viewModel.requestPermissions()
        }
    }
}

// Re-using the ChatBubble component for SwiftUI native implementation
struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        if message.isUser {
            HStack(alignment: .bottom, spacing: 12) {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("USER")
                        .font(.system(size: 11, weight: .semibold))
                        .kerning(1.5)
                        .foregroundColor(Color(hex: "#94a3b8")) // slate-400
                        .padding(.trailing, 4)
                    
                    Text(message.text)
                        .font(.system(size: 14))
                        .lineSpacing(4)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .background(Color(hex: "#3713ec"))
                        .cornerRadius(12)
                        .shadow(color: Color(hex: "#3713ec").opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .trailing)
                
                ZStack {
                    Circle()
                        .fill(Color(hex: "#1e293b"))
                        .frame(width: 32, height: 32)
                        .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.6))
                }
            }
        } else {
            HStack(alignment: .bottom, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#3713ec").opacity(0.2))
                        .frame(width: 32, height: 32)
                        .overlay(Circle().stroke(Color(hex: "#3713ec").opacity(0.3), lineWidth: 1))
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#3713ec"))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("ASSISTANT")
                        .font(.system(size: 11, weight: .semibold))
                        .kerning(1.5)
                        .foregroundColor(Color(hex: "#94a3b8")) // slate-400
                        .padding(.leading, 4)
                    
                    Text(message.text)
                        .font(.system(size: 14))
                        .lineSpacing(4)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .foregroundColor(Color(hex: "#e2e8f0")) // slate-200
                        .background(Color.white.opacity(0.05)) // glass-card
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .leading)
                
                Spacer()
            }
        }
    }
}

// Restored NavIcon for SymptomCheckupView backward compatibility
struct NavIcon: View {
    let icon: String
    let text: String
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isActive ? Color(hex: "#3713ec") : Color(hex: "#64748b"))
            
            Text(text)
                .font(.system(size: 10, weight: .bold))
                .kerning(1.5)
                .foregroundColor(isActive ? Color(hex: "#3713ec") : Color(hex: "#64748b"))
        }
    }
}

// Restored BlurView for SymptomCheckupView backward compatibility
extension View {
    func backdropBlur(radius: CGFloat) -> some View {
        self.background(BlurView(style: .systemUltraThinMaterialDark).opacity(0.8))
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
