import SwiftUI

struct FamilyHistoryChatView: View {
    @EnvironmentObject var router: StitchRouter
    @EnvironmentObject var assessment: AssessmentData
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#131022"),
                    Color(hex: "#251b4d"),
                    Color(hex: "#131022")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        router.navigate(to: .symptomCheckup)
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                    }
                    Spacer()
                    VStack(spacing: 4) {
                        Text("Health AI")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        HStack(spacing: 6) {
                            Circle().fill(Color.green).frame(width: 8, height: 8)
                            Text("Om is active")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "#94a3b8"))
                        }
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                }
                .padding()
                
                // Content
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Voice AI Orb
                    VStack(spacing: 32) {
                        ZStack {
                            Circle()
                                .stroke(Color(hex: "#3713ec").opacity(0.2), lineWidth: 1)
                                .frame(width: 192, height: 192)
                            
                            Circle()
                                .stroke(Color(hex: "#3713ec").opacity(0.4), lineWidth: 1)
                                .frame(width: 160, height: 160)
                            
                            Circle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#3713ec"), Color.purple, Color.pink]), startPoint: .topTrailing, endPoint: .bottomLeading))
                                .frame(width: 128, height: 128)
                                .shadow(color: Color(hex: "#3713ec").opacity(0.3), radius: 40, x: 0, y: 0)
                                .overlay(
                                    HStack(spacing: 4) {
                                        Capsule().fill(Color.white).frame(width: 4, height: 24).opacity(0.8)
                                        Capsule().fill(Color.white).frame(width: 4, height: 40)
                                        Capsule().fill(Color.white).frame(width: 4, height: 56).opacity(0.6)
                                        Capsule().fill(Color.white).frame(width: 4, height: 40)
                                        Capsule().fill(Color.white).frame(width: 4, height: 24).opacity(0.8)
                                    }
                                )
                        }
                        
                        VStack(spacing: 8) {
                            Text("Listening...")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            Text("Analyzing health patterns")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "#94a3b8"))
                        }
                    }
                    
                    Spacer()
                    
                    // Assistant Message
                    HStack(alignment: .top, spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.purple, Color(hex: "#3713ec")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 40, height: 40)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            
                            Image(systemName: "sparkles")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("ASSISTANT")
                                .font(.system(size: 13, weight: .semibold))
                                .kerning(1.0)
                                .foregroundColor(Color(hex: "#94a3b8"))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("I've noticed a high blood sugar reading in your latest log. ")
                                    .foregroundColor(.white) +
                                Text("Is anyone in your family Diabetic?")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "#60a5fa")) // blue-400
                            }
                            .font(.system(size: 16))
                            .lineSpacing(4)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            // Yes Button
                            Button(action: {
                                assessment.familyHistoryDiabetes = "Yes"
                                router.navigate(to: .result)
                            }) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(hex: "#3713ec"))
                                            .frame(width: 48, height: 48)
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 24, weight: .bold))
                                    }
                                    
                                    Text("Yes")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
                                .shadow(color: Color(hex: "#3713ec").opacity(0.4), radius: 20, x: 0, y: 0)
                            }
                            
                            // No Button
                            Button(action: {
                                assessment.familyHistoryDiabetes = "No"
                                router.navigate(to: .result)
                            }) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(hex: "#334155")) // slate-700
                                            .frame(width: 48, height: 48)
                                        Image(systemName: "xmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 24, weight: .bold))
                                    }
                                    
                                    Text("No")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
                            }
                        }
                        
                        Button(action: { router.navigate(to: .result) }) {
                            Text("I'm not sure, skip for now")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "#94a3b8"))
                                .padding(.vertical, 16)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}
