import SwiftUI

struct SymptomCheckupView: View {
    @EnvironmentObject var router: StitchRouter
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
                // Top Header (Small Orb)
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#3713ec").opacity(0.8), Color.pink.opacity(0.8)]), startPoint: .topTrailing, endPoint: .bottomLeading))
                            .frame(width: 80, height: 80)
                            .shadow(color: Color(hex: "#3713ec").opacity(0.4), radius: 20, x: 0, y: 0)
                            .shadow(color: Color.pink.opacity(0.2), radius: 40, x: 0, y: 0)
                        
                        Circle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 64, height: 64)
                            .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                            .backdropBlur(radius: 12)
                        
                        Image(systemName: "graphic.eq")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 20)
                    
                    Text("SYMPTOM CHECK-UP")
                        .font(.system(size: 10, weight: .bold))
                        .kerning(2.0)
                        .foregroundColor(Color.white.opacity(0.6))
                }
                .padding(.bottom, 24)
                
                ScrollView {
                    VStack(spacing: 32) {
                        
                        // Let's check other symptoms
                        SymptomAssistantChat(icon: "smart_toy", text: "No problem! Let's check some other symptoms instead.")
                        
                        // Anxious
                        VStack(spacing: 16) {
                            SymptomAssistantChat(icon: "brain.head.profile", text: "Do you feel nervous or anxious?")
                            
                            HStack {
                                Spacer()
                                Menu {
                                    Button("No", action: { assessment.anxietySelection = "No" })
                                    Button("Sometimes", action: { assessment.anxietySelection = "Sometimes" })
                                    Button("Frequently", action: { assessment.anxietySelection = "Frequently" })
                                } label: {
                                    HStack {
                                        Text(assessment.anxietySelection.isEmpty ? "Select frequency" : assessment.anxietySelection)
                                            .foregroundColor(assessment.anxietySelection.isEmpty ? Color(hex: "#94a3b8") : .white)
                                            .font(.system(size: 14))
                                        Spacer()
                                        Image(systemName: "chevron.up.chevron.down")
                                            .foregroundColor(Color(hex: "#94a3b8"))
                                    }
                                    .padding()
                                    .frame(width: 240)
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                                }
                            }
                        }
                        
                        // Numb Feet
                        if !assessment.anxietySelection.isEmpty {
                            VStack(spacing: 16) {
                            SymptomAssistantChat(icon: "shoeprints.fill", text: "Do you feel numb on your feet?")
                            
                            HStack {
                                Spacer()
                                HStack(spacing: 8) {
                                    SymptomChip(text: "Yes", isSelected: assessment.numbSelection == "Yes") { assessment.numbSelection = "Yes" }
                                    SymptomChip(text: "No", isSelected: assessment.numbSelection == "No") { assessment.numbSelection = "No" }
                                }
                                .frame(width: 240)
                            }
                        }
                        }
                        
                        // Sleep
                        if !assessment.numbSelection.isEmpty {
                            VStack(spacing: 16) {
                            SymptomAssistantChat(icon: "moon.zzz.fill", text: "Do you sleep well?")
                            
                            HStack {
                                Spacer()
                                HStack(spacing: 8) {
                                    SymptomChip(text: "Yes", isSelected: assessment.sleepSelection == "Yes") { assessment.sleepSelection = "Yes" }
                                    SymptomChip(text: "No", isSelected: assessment.sleepSelection == "No") { assessment.sleepSelection = "No" }
                                    SymptomChip(text: "Maybe", isSelected: assessment.sleepSelection == "Maybe") { assessment.sleepSelection = "Maybe" }
                                }
                                .frame(width: 300)
                            }
                        }
                        }
                        
                        // Heart
                        if !assessment.sleepSelection.isEmpty {
                            VStack(spacing: 16) {
                            SymptomAssistantChat(icon: "heart.fill", text: "Does your heart palpitate or feel heavy?")
                            
                            HStack {
                                Spacer()
                                HStack(spacing: 8) {
                                    SymptomChip(text: "Yes", isSelected: assessment.heartSelection == "Yes") {
                                        assessment.heartSelection = "Yes"
                                        // Once this is answered, auto-navigate to Family History according to the flow
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            router.navigate(to: .familyHistory)
                                        }
                                    }
                                    SymptomChip(text: "No", isSelected: assessment.heartSelection == "No") {
                                        assessment.heartSelection = "No"
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            router.navigate(to: .familyHistory)
                                        }
                                    }
                                }
                                .frame(width: 240)
                            }
                        }
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 150)
                }
            }
            
            // Bottom Mic & Nav
            VStack {
                Spacer()
                ZStack(alignment: .bottom) {
                    HStack { Spacer() }.frame(height: 80).background(Color(hex: "#131022").opacity(0.8)).backdropBlur(radius: 20).overlay(Rectangle().frame(height: 1).foregroundColor(Color.white.opacity(0.1)), alignment: .top)
                    
                    HStack {
                        Button(action: {
                            router.navigate(to: .welcome)
                        }) {
                            NavIcon(icon: "message.fill", text: "CHAT", isActive: true)
                        }
                        Spacer()
                        NavIcon(icon: "chart.xyaxis.line", text: "TRENDS", isActive: false)
                        Spacer().frame(width: 80)
                        NavIcon(icon: "heart.fill", text: "HEALTH", isActive: false)
                        Spacer()
                        NavIcon(icon: "person.fill", text: "PROFILE", isActive: false)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    
                    Button(action: {
                        // Normally this would trigger the mic, here we map manual navigation for flow testing
                        router.navigate(to: .familyHistory)
                    }) {
                        ZStack {
                            Circle().fill(Color(hex: "#3713ec")).frame(width: 64, height: 64).shadow(color: Color(hex: "#3713ec").opacity(0.4), radius: 20, x: 0, y: 0)
                            Image(systemName: "mic.fill").font(.system(size: 24)).foregroundColor(.white)
                        }
                    }
                    .offset(y: -40)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct SymptomAssistantChat: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#3713ec").opacity(0.2))
                    .frame(width: 32, height: 32)
                    .overlay(Circle().stroke(Color(hex: "#3713ec").opacity(0.3), lineWidth: 1))
                
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#3713ec"))
            }
            
            Text(text)
                .font(.system(size: 14))
                .lineSpacing(4)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .foregroundColor(Color(hex: "#e2e8f0"))
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)
                // Remove top-left corner curve like TailWind rounded-tl-none
                .cornerRadius(4, corners: [.topLeft])
                .overlay(CustomRoundedRectangle(cornerRadius: 16, cornersToStraighten: [.topLeft]).stroke(Color.white.opacity(0.1), lineWidth: 1))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            Spacer()
        }
    }
}

struct SymptomChip: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : Color(hex: "#e2e8f0"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color(hex: "#3713ec").opacity(0.5) : Color.white.opacity(0.05))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? Color(hex: "#3713ec") : Color.white.opacity(0.1), lineWidth: 1))
        }
    }
}

// Custom corner shaping
struct CustomRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    var cornersToStraighten: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        var corners: UIRectCorner = .allCorners
        if cornersToStraighten.contains(.topLeft) { corners.remove(.topLeft) }
        if cornersToStraighten.contains(.topRight) { corners.remove(.topRight) }
        if cornersToStraighten.contains(.bottomLeft) { corners.remove(.bottomLeft) }
        if cornersToStraighten.contains(.bottomRight) { corners.remove(.bottomRight) }
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
