//
//  DashboardView.swift
//  PersonalHealthTracker
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var healthKitManager = HealthKitManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if !healthKitManager.isAuthorized {
                        authorizationPrompt
                    } else {
                        metricsGrid
                        riskAnalysisSection
                    }
                }
                .padding()
            }
            .navigationTitle("Health Tracker")
            .background(Color(UIColor.systemGroupedBackground))
            .onAppear {
                healthKitManager.requestAuthorization { success in
                    if success {
                        healthKitManager.fetchAllData()
                    }
                }
            }
        }
    }
    
    private var authorizationPrompt: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            Text("Health Access Required")
                .font(.title2.bold())
            Text("This app requires access to Apple Health to track your Heart Rate, Blood Pressure, Steps, and Sleep.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Button("Grant Access") {
                healthKitManager.requestAuthorization { _ in }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    private var metricsGrid: some View {
        VStack(spacing: 16) {
            // Heart Rate
            MetricCardView(
                title: "Heart Rate",
                value: healthKitManager.heartRate != nil ? String(format: "%.0f", healthKitManager.heartRate!) : "--",
                unit: "bpm",
                iconName: "heart.fill",
                color: .red
            )
            
            // Blood Pressure
            let bpValue = (healthKitManager.bloodPressureSystolic != nil && healthKitManager.bloodPressureDiastolic != nil)
                ? String(format: "%.0f/%.0f", healthKitManager.bloodPressureSystolic!, healthKitManager.bloodPressureDiastolic!)
                : "--/--"
            
            MetricCardView(
                title: "Blood Pressure",
                value: bpValue,
                unit: "mmHg",
                iconName: "waveform.path.ecg",
                color: .purple
            )
            
            // Blood Sugar
            MetricCardView(
                title: "Blood Sugar",
                value: healthKitManager.bloodGlucose != nil ? String(format: "%.0f", healthKitManager.bloodGlucose!) : "--",
                unit: "mg/dL",
                iconName: "drop.fill",
                color: .pink
            )
            
            // Steps
            MetricCardView(
                title: "Steps Today",
                value: String(format: "%.0f", healthKitManager.stepsCount),
                unit: "steps",
                iconName: "figure.walk",
                color: .orange
            )
            
            // Sleep
            MetricCardView(
                title: "Sleep (Last Night)",
                value: healthKitManager.sleepDurationHours != nil ? String(format: "%.1f", healthKitManager.sleepDurationHours!) : "--",
                unit: "hrs",
                iconName: "moon.zzz.fill",
                color: .indigo
            )
        }
    }
    
    private var riskAnalysisSection: some View {
        let result = RiskAnalyzer.analyze(
            heartRate: healthKitManager.heartRate,
            bpSystolic: healthKitManager.bloodPressureSystolic,
            bpDiastolic: healthKitManager.bloodPressureDiastolic,
            bloodGlucose: healthKitManager.bloodGlucose,
            steps: healthKitManager.stepsCount,
            sleepHours: healthKitManager.sleepDurationHours
        )
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("Overall Status: \(result.overallStatus.rawValue)")
                .font(.headline)
                .foregroundColor(statusColor(for: result.overallStatus))
                .padding(.bottom, 4)
            
            if result.warnings.isEmpty {
                Text("All metrics look optimal. Keep up the good work!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                ForEach(result.warnings, id: \.self) { warning in
                    HStack(alignment: .top) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                        Text(warning)
                            .font(.subheadline)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func statusColor(for status: HealthRiskStatus) -> Color {
        switch status {
        case .optimal: return .green
        case .normal: return .blue
        case .warning: return .orange
        case .highRisk: return .red
        }
    }
}
