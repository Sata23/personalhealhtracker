import SwiftUI

struct WelcomeScreenView: View {
    @EnvironmentObject var router: StitchRouter
    @EnvironmentObject var assessment: AssessmentData
    
    var body: some View {
        ZStack {
            // Background Mesh Gradient Mock
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#b8e2f8"), // hsla(199, 89%, 84%) roughly
                    Color(hex: "#fce7f3") // bg base pink
                ]),
                center: .topLeading,
                startRadius: 0,
                endRadius: 800
            )
            .edgesIgnoringSafeArea(.all)
            
            // Background Elements (Circles)
            Circle()
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                .frame(width: 300, height: 300)
            Circle()
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                .frame(width: 250, height: 250)
            Circle()
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                .frame(width: 200, height: 200)
            
            VStack {
                // Top Content Image / Icon
                VStack(spacing: 24) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.45))
                            .frame(width: 80, height: 80)
                            .shadow(color: Color.black.opacity(0.02), radius: 10, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
                            )
                        
                        Image(systemName: "figure.mind.and.body")
                            .font(.system(size: 32))
                            .foregroundColor(Color(hex: "#6366f1"))
                        
                        // Small overlapping badge
                        Circle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Image(systemName: "music.note")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Color(hex: "#818cf8"))
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            .offset(x: 36, y: -36)
                    }
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Text("Your Health Journey")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(hex: "#1e293b"))
                                .multilineTextAlignment(.center)
                            
                            Text("ॐ")
                                .font(.custom("Palatino", size: 24)) // Serif style approximate
                                .foregroundColor(Color(hex: "#6366f1"))
                                .italic()
                        }
                        
                        Text("Personalized spiritual & AI insights for you.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#64748b"))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Login Buttons Card
                ZStack {
                    // Watermark OM
                    Text("ॐ")
                        .font(.custom("Palatino", size: 180))
                        .fontWeight(.thin)
                        .foregroundColor(Color(hex: "#6366f1"))
                        .opacity(0.04)
                        .offset(y: -40)
                    
                    VStack(spacing: 16) {
                        // Apple Setup
                        Button(action: {
                            resetAssessment(assessment)
                            // Route directly to chat_1
                            router.navigate(to: .vitalIndicators)
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "applelogo")
                                    .font(.system(size: 20))
                                Text("Continue with Apple")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.black)
                            .cornerRadius(20)
                        }
                        
                        // Google Setup (Mocked icon with SF Symbol)
                        Button(action: {
                            resetAssessment(assessment)
                            router.navigate(to: .vitalIndicators)
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "g.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(hex: "#4285F4"))
                                Text("Continue with Google")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(Color(hex: "#334155"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black.opacity(0.1), lineWidth: 1))
                            .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
                        }
                        
                        // Divider
                        HStack {
                            VStack { Divider().background(Color.black.opacity(0.1)) }
                            Text("OR").font(.caption2).fontWeight(.bold).foregroundColor(Color(hex: "#94a3b8")).padding(.horizontal, 8)
                            VStack { Divider().background(Color.black.opacity(0.1)) }
                        }
                        .padding(.vertical, 4)
                        
                        // Email Setup
                        Button(action: {
                            resetAssessment(assessment)
                            router.navigate(to: .vitalIndicators)
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 20))
                                Text("Continue with Email")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(Color(hex: "#6366f1"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "#eef2ff").opacity(0.5)) // indigo-50
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(hex: "#6366f1").opacity(0.2), lineWidth: 1))
                        }
                        
                        Text("By continuing, you agree to our Terms of Service and Privacy Policy.")
                            .font(.caption2)
                            .foregroundColor(Color(hex: "#94a3b8"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                    }
                }
                .padding(32)
                .background(Color.white.opacity(0.45))
                .cornerRadius(40)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.white.opacity(0.6), lineWidth: 1))
                .shadow(color: Color(hex: "#e0e7ff").opacity(0.5), radius: 30, x: 0, y: 20)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundColor(Color(hex: "#64748b"))
                        Text("Log in")
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#6366f1"))
                    }
                    .font(.system(size: 14, weight: .medium))
                }
                .padding(.bottom, 60)
            }
            
            // Bottom banner soft om ambient playing
            VStack {
                Spacer()
                HStack(spacing: 12) {
                    Image(systemName: "music.note")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#6366f1").opacity(0.6))
                    Text("SOFT OM AMBIENT PLAYING")
                        .font(.system(size: 10, weight: .bold))
                        .kerning(1.5)
                        .foregroundColor(Color(hex: "#94a3b8"))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.4))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.4), lineWidth: 1))
                .padding(.bottom, 24)
            }
        }
    }
    
    // Helper to reset the shared state when starting a new flow
    private func resetAssessment(_ assessment: AssessmentData) {
        assessment.bloodSugar = ""
        assessment.bloodPressure = ""
        assessment.anxietySelection = ""
        assessment.numbSelection = ""
        assessment.sleepSelection = ""
        assessment.heartSelection = ""
        assessment.familyHistoryDiabetes = ""
    }
}
