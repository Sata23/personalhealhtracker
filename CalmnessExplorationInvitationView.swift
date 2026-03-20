import SwiftUI

struct CalmnessExplorationInvitationView: View {
    @EnvironmentObject var router: StitchRouter
    @EnvironmentObject var assessment: AssessmentData
    
    // Animation states
    @State private var isPulsing = false
    @State private var isListening = true
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#221019"),
                    Color(hex: "#3a1528"),
                    Color(hex: "#221019")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                // Header
                HStack {
                    Button(action: {
                        router.navigate(to: .result) // Back to result page
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#ee2b8c").opacity(0.1))
                                .frame(width: 40, height: 40)
                                .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                            
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    
                    Spacer()
                    
                    Text("CALMNESS EXPLORATION")
                        .font(.system(size: 14, weight: .medium))
                        .kerning(1.0)
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    Spacer()
                    
                    // Invisible placeholder for symmetry
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                Spacer()
                
                // AI Voice Orb
                ZStack {
                    // Outer blur/glow
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [Color(hex: "#ee2b8c").opacity(0.3), Color(hex: "#3a1528").opacity(0.0)]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 150
                            )
                        )
                        .frame(width: 300, height: 300)
                        .scaleEffect(isPulsing ? 1.1 : 0.9)
                        .opacity(isPulsing ? 1.0 : 0.6)
                        .animation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isPulsing)
                        
                    // Inner ring
                    Circle()
                        .fill(Color(hex: "#ee2b8c").opacity(0.1))
                        .frame(width: 192, height: 192)
                        .overlay(Circle().stroke(Color(hex: "#ee2b8c").opacity(0.3), lineWidth: 1))
                        .shadow(color: Color(hex: "#ee2b8c").opacity(0.3), radius: 50, x: 0, y: 0)
                        .scaleEffect(isPulsing ? 1.05 : 0.95)
                        .animation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(0.2), value: isPulsing)
                    
                    // Core orb
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#ee2b8c"), Color(hex: "#60a5fa")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 128, height: 128)
                        .opacity(0.8)
                    
                    Image(systemName: "waveform")
                        .font(.system(size: 48))
                        .foregroundColor(.white)
                        .scaleEffect(isPulsing ? 1.0 : 0.9)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isPulsing)
                }
                
                Spacer()
                
                // Typography
                VStack(spacing: 16) {
                    Text("In the meantime, you can explore our libraries to stay calm.")
                        .font(.system(size: 18, weight: .light))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(hex: "#cbd5e1")) // slate-300
                        .padding(.horizontal, 40)
                    
                    Text("Say with me \"Om\"")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                    
                    // Listening Indicator
                    VStack(spacing: 12) {
                        HStack(spacing: 4) {
                            ForEach(0..<5) { index in
                                Capsule()
                                    .fill(Color(hex: "#ee2b8c"))
                                    .frame(width: 4, height: [16.0, 32.0, 24.0, 40.0, 16.0][index])
                                    .scaleEffect(y: isPulsing ? 1.2 : 0.8, anchor: .center)
                                    .animation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true).delay(Double(index) * 0.1), value: isPulsing)
                            }
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 14))
                            Text("LISTENING")
                                .font(.system(size: 12, weight: .semibold))
                                .kerning(1.5)
                        }
                        .foregroundColor(Color(hex: "#ee2b8c").opacity(0.8))
                    }
                }
                
                Spacer()
                
                // Action Area
                Button(action: {
                    router.navigate(to: .yogaPlayer)
                }) {
                    HStack(spacing: 8) {
                        Text("Explore Libraries")
                        Image(systemName: "text.book.closed.fill")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "#ee2b8c").opacity(0.1))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 60)
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
                    NavIcon(icon: "sparkles", text: "Practice", isActive: true)
                    Spacer()
                    NavIcon(icon: "heart.fill", text: "Health", isActive: false)
                    Spacer()
                    NavIcon(icon: "person.fill", text: "Profile", isActive: false)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color(hex: "#221019").opacity(0.8))
                .backdropBlur(radius: 20)
                .overlay(Rectangle().frame(height: 1).foregroundColor(Color.white.opacity(0.05)), alignment: .top)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            isPulsing = true
        }
    }
}

struct CalmnessExplorationInvitationView_Previews: PreviewProvider {
    static var previews: some View {
        CalmnessExplorationInvitationView()
            .environmentObject(StitchRouter())
            .environmentObject(AssessmentData())
    }
}
