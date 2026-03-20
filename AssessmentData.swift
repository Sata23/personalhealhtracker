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
    
    // Computes overall Risk Score based on SMAI Evaluation
    var riskDiagnosis: (score: String, recommendation: String, isHighRisk: Bool) {
        var riskCount = 0
        
        // 1. Blood Pressure Check (Normal < 120/80)
        let bpParts = bloodPressure.split(separator: "/")
        if bpParts.count == 2, let systolic = Double(bpParts[0]), let diastolic = Double(bpParts[1]) {
            if systolic > 120 || diastolic > 80 {
                riskCount += 1
            }
        }
        
        // 2. Blood Sugar Check (Fasting normal < 100)
        if let sugar = Double(bloodSugar), sugar > 100 {
            riskCount += 1
        }
        
        // 3. Symptoms Check
        if numbSelection == "Yes" { riskCount += 1 }
        if heartSelection == "Yes" { riskCount += 1 }
        if sleepSelection == "No" { riskCount += 1 }
        if anxietySelection == "Frequently" { riskCount += 1 }
        
        // 4. Family History
        if familyHistoryDiabetes == "Yes" { riskCount += 1 }
        
        // Determine Result
        if riskCount >= 2 {
            return (
                score: "Poor",
                recommendation: "High Risk Detected: Immediate medical attention and lifestyle modifications are advised.",
                isHighRisk: true
            )
        } else if riskCount == 1 {
            return (
                score: "Moderate",
                recommendation: "Elevated Risk Detected: Monitor health carefully and consider lifestyle improvements.",
                isHighRisk: true
            )
        } else {
            return (
                score: "Good",
                recommendation: "Low Risk: Keep up the excellent work maintaining a healthy lifestyle!",
                isHighRisk: false
            )
        }
    }
}
