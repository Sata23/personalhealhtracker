//
//  RiskAnalyzer.swift
//  PersonalHealthTracker
//

import Foundation

enum HealthRiskStatus: String {
    case optimal = "Optimal"
    case normal = "Normal"
    case warning = "Needs Attention"
    case highRisk = "High Risk"
}

struct HealthRiskResult {
    let overallStatus: HealthRiskStatus
    let warnings: [String]
}

class RiskAnalyzer {
    
    // Analyze all metrics to determine if there are risks
    static func analyze(
        heartRate: Double?,
        bpSystolic: Double?,
        bpDiastolic: Double?,
        bloodGlucose: Double?,
        steps: Double,
        sleepHours: Double?
    ) -> HealthRiskResult {
        
        var warnings: [String] = []
        var status: HealthRiskStatus = .optimal
        
        // 1. Heart Rate (Assuming resting/general reading)
        // Normal resting HR is typically 60-100 bpm
        if let hr = heartRate {
            if hr > 100 {
                warnings.append("High Heart Rate (\(Int(hr)) bpm).")
            } else if hr < 50 {
                warnings.append("Low Heart Rate (\(Int(hr)) bpm).")
            }
        } else {
            warnings.append("No recent heart rate data.")
        }
        
        // 2. Blood Pressure
        // User requested: > 180 / 80 flag risk
        // Standard:
        // Normal: < 120 / < 80
        // Elevated: 120-129 / < 80
        // High Stage 1: 130-139 / 80-89
        // High Stage 2: >= 140 / >= 90
        if let sys = bpSystolic, let dia = bpDiastolic {
            if sys > 180 || dia > 80 {
                warnings.append("CRITICAL: Blood Pressure is very high (\(Int(sys))/\(Int(dia))). Seek immediate medical attention.")
                status = .highRisk
            } else if sys >= 140 || dia >= 90 {
                warnings.append("High Blood Pressure Stage 2 (\(Int(sys))/\(Int(dia))). Consult a doctor.")
                if status != .highRisk { status = .highRisk }
            } else if sys >= 130 || dia >= 80 {
                warnings.append("High Blood Pressure Stage 1 (\(Int(sys))/\(Int(dia))).")
                if status != .highRisk { status = .warning }
            } else if sys >= 120 {
                warnings.append("Elevated Blood Pressure (\(Int(sys))/\(Int(dia))).")
                if status == .optimal { status = .normal }
            }
        } else {
            warnings.append("No recent blood pressure data.")
        }
        
        // 3. Blood Sugar
        // User requested: > 200 mg/dl flag risk
        if let glucose = bloodGlucose {
            if glucose > 200 {
                warnings.append("CRITICAL: Blood Sugar is very high (\(Int(glucose)) mg/dL). Seek medical attention.")
                status = .highRisk
            }
        }
        
        // 4. Steps
        // Goal: 10,000 typically represents an active lifestyle. Under 5,000 is sedentary.
        if steps < 5000 {
            warnings.append("Low daily activity (\(Int(steps)) steps). Try to walk more.")
            if status == .optimal { status = .normal }
        }
        
        // 4. Sleep
        // Goal: 7-9 hours for adults
        if let sleep = sleepHours {
            if sleep < 6 {
                warnings.append("Inadequate sleep (\(String(format: "%.1f", sleep)) hrs). Aim for 7-9 hours.")
                if status == .optimal || status == .normal { status = .warning }
            } else if sleep > 10 {
                warnings.append("Excessive sleep recorded (\(String(format: "%.1f", sleep)) hrs).")
            }
        } else {
            warnings.append("No recent sleep data.")
        }
        
        // Finalize Status
        if warnings.count >= 3 && status != .highRisk {
            // Multiple warning flags bump up the severity
            status = .highRisk
        } else if warnings.count > 0 && status == .optimal {
            status = .normal
        }
        
        return HealthRiskResult(overallStatus: status, warnings: warnings)
    }
}
