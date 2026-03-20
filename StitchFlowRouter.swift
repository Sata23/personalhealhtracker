import SwiftUI
import Combine

class AssessmentData: ObservableObject {
    // Vitals
    @Published var bloodSugar: String = ""
    @Published var bloodPressure: String = ""
    
    // Symptoms
    @Published var anxietySelection: String = ""
    @Published var numbSelection: String = ""
    @Published var sleepSelection: String = ""
    @Published var heartSelection: String = ""
    
    // Family History
    @Published var familyHistoryDiabetes: String = "" // "Yes" or "No"
    
    // Add a property to collect PPBS if we ever need it separately; for now we'll assume `bloodSugar` is fasting and use it for logic.
    // If we wanted to distinguish, we could add a new field. We'll stick to using the general bloodSugar field.
    
    // Computes overall Risk Score based on SMAI Evaluation
    var riskDiagnosis: (score: String, recommendation: String, reasoning: String, isHighRisk: Bool) {
        // Parse numerical values
        let sugar = Double(bloodSugar) ?? 0.0
        var systolic = 0.0
        var diastolic = 0.0
        
        let bpParts = bloodPressure.split(separator: "/")
        if bpParts.count == 2, let sys = Double(bpParts[0]), let dia = Double(bpParts[1]) {
            systolic = sys
            diastolic = dia
        }
        
        let hasFamilyHistory = (familyHistoryDiabetes == "Yes")
        let hasHighBP = (systolic > 140) || (diastolic > 80)
        
        let universalAdvice = "\n\nRemember, in all cases, the advice is to exercise like Yoga, meditation & walk for 45 minutes to 1 hour regularly, eat healthy, low glycemic food, follow a strict discipline and sleep well."
        
        // Tier 1: Poor / High Risk
        // BS > 180 (Fasting) & PPBS > 200 (For simplicity, using sugar > 180), BP > 140/80, Family History == true.
        // We will make it slightly broader so it hits if ALL 3 are bad.
        if sugar > 180 && hasHighBP && hasFamilyHistory {
            return (
                score: "Poor",
                recommendation: "Your health score is Poor and you are at a high health risk, please consult a doctor immediately. You might be a Type 2 Diabetic. Please consult your doctor and a fitness coach immediately." + universalAdvice,
                reasoning: "We have derived this result because you have a family history of diabetes & hypertension, alongside high fasting and post-prandial blood sugar levels.",
                isHighRisk: true
            )
        }
        
        // Tier 2: Moderately High
        // BS > 180, BP < 140/80, Family History == true.
        if sugar > 180 && !hasHighBP && hasFamilyHistory {
            return (
                score: "Moderately High",
                recommendation: "You are at moderately high risk of health. Please keep a control on your diet, eat low glycemic food, walk & exercise regularly, and you might want to consult a dietician as well as a good doctor. You might be a pre-diabetic or diabetic. Repeat the test at the lab. If no progress after 7 days, keep monitoring for 2 weeks. If still no improvement, please see a doctor." + universalAdvice,
                reasoning: "We have derived this result because while your blood pressure is under control, your blood sugar is elevated and you have a family history.",
                isHighRisk: true
            )
        }
        
        // Tier 3: Low/Moderate
        // Morning BS > 180, BP < 140/80, Family History == false.
        if sugar > 180 && !hasHighBP && !hasFamilyHistory {
            return (
                score: "Moderate",
                recommendation: "You must maintain a healthy diet, walk & exercise regularly, and keep a routine check on your blood pressure & blood sugar regularly. You'll be fine. If you like, you may want to see a doctor's advice after doing a blood test & checking your BP reading. Keep a check on diet, focus on low glycemic index food." + universalAdvice,
                reasoning: "We have derived this result because your morning blood sugar is elevated despite normal blood pressure and no family history.",
                isHighRisk: false
            )
        }
        
        // Tier 4: Good/Low
        // Morning BS < 140, BP < 140/80 (Assuming everything else that is not > 180/High BP falls to here or moderate)
        return (
            score: "Good",
            recommendation: "You might be at a low health risk, but keep the winning streak on! Exercise, walk regularly for 45 minutes to 1 hour, eat fibrous dietary food, and check your pressure and sugar regularly." + universalAdvice,
            reasoning: "We have derived this result because your blood sugar and blood pressure are within healthy ranges.",
            isHighRisk: false
        )
    }
}

enum StitchScreen: Hashable {
    case welcome
    case vitalIndicators
    case symptomCheckup
    case familyHistory
    case result
    case calmnessTour
    case yogaPlayer

class StitchRouter: ObservableObject {
    @Published var currentScreen: StitchScreen = .welcome
    
    func navigate(to screen: StitchScreen) {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.currentScreen = screen
        }
    }
}

struct StitchMainFlowView: View {
    @StateObject private var router = StitchRouter()
    @StateObject private var assessment = AssessmentData()
    
    var body: some View {
        ZStack {
            switch router.currentScreen {
            case .welcome:
                WelcomeScreenView()
                    .environmentObject(router)
                    .environmentObject(assessment)
                    .transition(.opacity)
            case .vitalIndicators:
                VitalIndicatorsView()
                    .environmentObject(router)
                    .environmentObject(assessment)
                    .transition(.move(edge: .trailing))
            case .symptomCheckup:
                SymptomCheckupView()
                    .environmentObject(router)
                    .environmentObject(assessment)
                    .transition(.move(edge: .trailing))
            case .familyHistory:
                FamilyHistoryChatView()
                    .environmentObject(router)
                    .environmentObject(assessment)
                    .transition(.move(edge: .trailing))
            case .result:
                Type2DiabetesResultView()
                    .environmentObject(router)
                    .environmentObject(assessment)
                    .transition(.scale)
            case .calmnessTour:
                CalmnessExplorationInvitationView()
                    .environmentObject(router)
                    .environmentObject(assessment)
                    .transition(.move(edge: .bottom))
            case .yogaPlayer:
                YogaSessionPlayerView()
                    .environmentObject(router)
                    .transition(.opacity)
            }
        }
    }
}
