import SwiftUI

struct Type2DiabetesResultView: View {
    @EnvironmentObject var router: StitchRouter
    @EnvironmentObject var assessment: AssessmentData
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.pink.opacity(0.1),
                    Color(hex: "#131022"),
                    Color(hex: "#3713ec").opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        router.navigate(to: .familyHistory)
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                    }
                    Spacer()
                    Text("Risk Analysis")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // AI Voice Orb
                        analysisHeader
                        
                        // User Profile Section
                        userProfileSection
                        
                        // Main Results Card
                        mainResultsCard
                        
                        // Action Button
                        actionButtonSection
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            // Bottom Sticky Navigation matching CSS sticky bottom-0 z-20
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        router.navigate(to: .welcome)
                    }) {
                        NavIcon(icon: "house.fill", text: "Home", isActive: false)
                    }
                    Spacer()
                    NavIcon(icon: "heart.fill", text: "Health", isActive: true)
                    Spacer()
                    NavIcon(icon: "person.2.fill", text: "Doctors", isActive: false)
                    Spacer()
                    NavIcon(icon: "person.fill", text: "Profile", isActive: false)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color(hex: "#131022").opacity(0.8))
                .backdropBlur(radius: 20)
                .overlay(Rectangle().frame(height: 1).foregroundColor(Color.white.opacity(0.05)), alignment: .top)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    // MARK: - Subviews
    
    @ViewBuilder
    private var analysisHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#1e293b"))
                    .frame(width: 64, height: 64)
                    .overlay(Circle().stroke(Color(hex: "#3713ec").opacity(0.3), lineWidth: 1))
                
                Image(systemName: "waveform")
                    .font(.system(size: 28))
                    .foregroundColor(Color(hex: "#3713ec"))
            }
            
            Text("AI PROCESSING COMPLETE")
                .font(.system(size: 10, weight: .semibold))
                .kerning(2.0)
                .foregroundColor(Color(hex: "#94a3b8")) // slate-400
        }
        .padding(.top, 24)
    }
    
    @ViewBuilder
    private var userProfileSection: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color(hex: "#1e293b"))
                    .frame(width: 96, height: 96)
                    .overlay(Circle().stroke(assessment.riskDiagnosis.isHighRisk ? Color(hex: "#3713ec").opacity(0.5) : Color.green.opacity(0.5), lineWidth: 2))
                
                Image(systemName: "person.fill")
                    .font(.system(size: 48))
                    .foregroundColor(Color.white.opacity(0.6))
                
                if assessment.riskDiagnosis.isHighRisk {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 24, height: 24)
                        .overlay(Circle().stroke(Color(hex: "#131022"), lineWidth: 2))
                        .overlay(Image(systemName: "exclamationmark").font(.system(size: 14, weight: .bold)).foregroundColor(.white))
                } else {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 24, height: 24)
                        .overlay(Circle().stroke(Color(hex: "#131022"), lineWidth: 2))
                        .overlay(Image(systemName: "checkmark").font(.system(size: 14, weight: .bold)).foregroundColor(.white))
                }
            }
            
            Text("Shantanu")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            Text("Health Assessment Result")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#94a3b8"))
        }
    }
    
    @ViewBuilder
    private var mainResultsCard: some View {
        VStack(spacing: 24) {
            VStack(spacing: 4) {
                Text("DIAGNOSIS")
                    .font(.system(size: 12, weight: .bold))
                    .kerning(2.0)
                    .foregroundColor(assessment.riskDiagnosis.isHighRisk ? Color.red.opacity(0.8) : Color.green.opacity(0.8))
                
                Text("Health Score: \(assessment.riskDiagnosis.score)")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(assessment.riskDiagnosis.isHighRisk ? Color.red : Color.green)
            }
            
            Divider().background(Color.white.opacity(0.1))
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    Image(systemName: "doc.text")
                        .foregroundColor(Color(hex: "#3713ec"))
                        .font(.system(size: 20))
                    Text(assessment.riskDiagnosis.reasoning)
                        .foregroundColor(Color(hex: "#e2e8f0"))
                        .font(.system(size: 16))
                }
                
                HStack(alignment: .top, spacing: 16) {
                    Image(systemName: assessment.riskDiagnosis.isHighRisk ? "exclamationmark.triangle.fill" : "hand.thumbsup.fill")
                        .foregroundColor(assessment.riskDiagnosis.isHighRisk ? Color(hex: "#f87171") : Color.green)
                        .font(.system(size: 20))
                    
                    Text(assessment.riskDiagnosis.recommendation)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(assessment.riskDiagnosis.isHighRisk ? Color(hex: "#fecaca") : Color.white)
                }
                .padding()
                .background(assessment.riskDiagnosis.isHighRisk ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(assessment.riskDiagnosis.isHighRisk ? Color.red.opacity(0.2) : Color.green.opacity(0.2), lineWidth: 1))
            }
            
    @ViewBuilder
    private var actionButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                // Proceed to the destressing tour
                router.navigate(to: .calmnessTour)
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                    Text("Start Destressing Tour")
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(hex: "#3713ec"))
                .cornerRadius(12)
                .shadow(color: Color(hex: "#3713ec").opacity(0.4), radius: 20, x: 0, y: 0)
            }
            
            Text("This assessment is for informational purposes only and is not a substitute for professional medical advice.")
                .font(.system(size: 10))
                .italic()
                .multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "#64748b")) // slate-500
                .padding(.horizontal, 32)
        }
        .padding(.bottom, 100)
    }
}
