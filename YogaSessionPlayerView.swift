import SwiftUI
import AVKit

struct YogaSessionPlayerView: View {
    @EnvironmentObject var router: StitchRouter
    @State private var isAIPracticeEnabled = true
    
    var body: some View {
        ZStack {
            // Background Gradient Mesh
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#221019"),
                    Color(hex: "#2d1622"),
                    Color(hex: "#221019")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    // Header
                    HStack {
                        Button(action: {
                            router.navigate(to: .calmnessTour)
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "#ee2b8c").opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        }
                        
                        Spacer()
                        
                        Text("YOGA SESSION")
                            .font(.system(size: 16, weight: .semibold))
                            .kerning(0.5)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            // Share action
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "#ee2b8c").opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                    
                    // Video Player Placeholder
                    ZStack(alignment: .bottom) {
                        // Background image/video area
                        Rectangle()
                            .fill(Color.black.opacity(0.6))
                            .aspectRatio(16/9, contentMode: .fill)
                            .overlay(
                                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuC_vOVdC3-ijtUh4WLOO8VOj6UqgY9fTnKerJKZUif1OWKmLbgpHWIjp91bMDw9PAC6MVtN7Fie_TVUl8O8PVNAyrt6lVbOAwoQVi2y-7vgoPjRj-dkMaz0zCFBtdvLioivUJuQ0HKdnDEoVz-oVgklbJ9Yi5yoTe7CsP-L04z1HajQrJuSRyX-UBolRuXxxidiwVZ1jFkX3cCgyoXEHTJTDejUYVduQl-EwFZ4LV052CWqv_e1ZNfppQynKoswQI0_DxvLNO8z_WU")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                            )
                            .clipped()
                        
                        // Glassmorphic Controls Overlay
                        ZStack {
                            Color.black.opacity(0.3)
                            
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 64, height: 64)
                                .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                                .backdropBlur(radius: 12)
                            
                            Image(systemName: "play.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                                .offset(x: 2) // optical alignment
                        }
                        
                        // Progress Bar Overlay
                        VStack(spacing: 8) {
                            HStack(spacing: 8) {
                                Capsule()
                                    .fill(Color(hex: "#ee2b8c"))
                                    .frame(height: 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .overlay(
                                        GeometryReader { geo in
                                            Capsule()
                                                .fill(Color(hex: "#ee2b8c"))
                                                .frame(width: geo.size.width * 0.35)
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 12, height: 12)
                                                .shadow(color: .white, radius: 4)
                                                .position(x: geo.size.width * 0.35, y: geo.size.height / 2)
                                        }
                                    )
                                
                                Capsule()
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 4)
                                    .frame(maxWidth: .infinity)
                            }
                            
                            HStack {
                                Text("08:42")
                                    .font(.system(size: 10, weight: .medium))
                                    .kerning(1.0)
                                    .foregroundColor(Color.white.opacity(0.8))
                                Spacer()
                                Text("24:00")
                                    .font(.system(size: 10, weight: .medium))
                                    .kerning(1.0)
                                    .foregroundColor(Color.white.opacity(0.8))
                            }
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]), startPoint: .bottom, endPoint: .top))
                    }
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1).padding(.horizontal, 16))
                    
                    // Session Info Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Sun Salutation")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Level: Beginner • Vinyasa Flow")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: "#ee2b8c"))
                            }
                            Spacer()
                            Text("FREE")
                                .font(.system(size: 12, weight: .bold))
                                .kerning(1.0)
                                .foregroundColor(Color(hex: "#ee2b8c"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color(hex: "#ee2b8c").opacity(0.2))
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#ee2b8c").opacity(0.3), lineWidth: 1))
                        }
                        
                        HStack(spacing: 24) {
                            HStack(spacing: 8) {
                                Image(systemName: "clock")
                                    .foregroundColor(Color(hex: "#ee2b8c"))
                                Text("24 mins")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#cbd5e1")) // slate-300
                            }
                            HStack(spacing: 8) {
                                Image(systemName: "flame")
                                    .foregroundColor(Color(hex: "#ee2b8c"))
                                Text("180 kcal")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#cbd5e1"))
                            }
                        }
                        
                        Divider().background(Color.white.opacity(0.1))
                        
                        // AI Toggle
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#ee2b8c"), Color(hex: "#3b82f6")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 32, height: 32)
                                Image(systemName: "sparkles")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Practice with AI")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("Real-time form correction")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(hex: "#94a3b8")) // slate-400
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $isAIPracticeEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#ee2b8c")))
                        }
                    }
                    .padding(20)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1).padding(.horizontal, 16).padding(.top, 16))
                    
                    // Up Next Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Up Next")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                            Button("View All") {
                                // View all action
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#ee2b8c"))
                        }
                        .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                // Card 1
                                upNextCard(
                                    title: "Mindful Morning Flow",
                                    difficulty: "Intermediate",
                                    duration: "15 MIN",
                                    imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuC9K73lr3-62yfEvfkg55TiuzDIrVHSupp7nfX5992saPZkD6McPhNLg5OrL0JU7npCO-NzYVhAgyovmd7HpKpn3Ew_7RPLu9TCNCTMERhN6x3S_Fyof3lYWjKRDJpIBMZoL1NrhbRlkvhdEC2C_hXqaM1ienoSB0p9r_9rGz8o40E_GjVD3wsPf27g1R7tSZ5RpFpzwFwzokbHWzrf97HGzJhluT8HUgN8d40pI6uxws89mGnyZKDp651pIpHMf2pujUxlLfQRXmg"
                                )
                                
                                // Card 2
                                upNextCard(
                                    title: "Deep Core Strength",
                                    difficulty: "Advanced",
                                    duration: "45 MIN",
                                    imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuBvJQdgD_2tn23q6Ijmomx6jNng-sLIbeN4S-gkaMBv2TOLc33VYcRsYnv_c0nV_hBSrvcbMfKMBTdryNpgg1HtUQK3Of0BjozYrFGfIjqLImazFP7GIGK0bhMYy5OKkmOn_sIyJNozSZb7orBdkef2HDjgrZWeg8HOuSLp4_aTejnjZTlia8nE8BHJHZmhvVjMzuAvy_pd84oKx_XSYrDNOPYzpDoCq725QGreIWyizNnfJx2pd7toVeDEtfzUAXJRNvY2U5ahuuQ"
                                )
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 100)
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
                    NavIcon(icon: "figure.walk", text: "Practice", isActive: true)
                    Spacer()
                    NavIcon(icon: "chart.bar.fill", text: "Insights", isActive: false)
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
    }
    
    @ViewBuilder
    private func upNextCard(title: String, difficulty: String, duration: String, imageUrl: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 128)
                .clipped()
                
                Color.black.opacity(0.2) // Overlay
                
                Text(duration)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.6))
                    .backdropBlur(radius: 8)
                    .cornerRadius(4)
                    .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("Difficulty: \(difficulty)")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#94a3b8")) // slate-400
            }
            .padding(12)
        }
        .frame(width: 256)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.05), lineWidth: 1))
    }
}

struct YogaSessionPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        YogaSessionPlayerView()
            .environmentObject(StitchRouter())
    }
}
