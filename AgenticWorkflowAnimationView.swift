import SwiftUI

struct AgenticWorkflowAnimationView: View {
    @State private var issues: [Issue] = []
    @State private var processedCount: Int = 0
    @State private var totalAttempted: Int = 0
    @State private var isProcessing = false
    @State private var progress: Double = 0.0
    
    // Timer for generating new issues
    let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    
    struct Issue: Identifiable {
        let id = UUID()
        var position: CGFloat = -100
        var isResolved: Bool = false
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "#0f172a")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                // Title Area
                VStack(spacing: 8) {
                    Text("THE AGENTIC WORKFORCE")
                        .font(.system(size: 24, weight: .black))
                        .kerning(4)
                        .foregroundColor(.white)
                    
                    Text("Claude 4.5 Sonnet Solving GitHub Issues")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#94a3b8"))
                }
                .padding(.top, 40)
                
                // Pipeline Visualization
                ZStack {
                    // Pipeline Track
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.05))
                        .frame(height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    
                    // Central Agent Node
                    ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#3713ec"), Color(hex: "#ee2b8c")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 80, height: 80)
                            .shadow(color: Color(hex: "#3713ec").opacity(0.5), radius: 20, x: 0, y: 0)
                            .scaleEffect(isProcessing ? 1.1 : 1.0)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(isProcessing ? 360 : 0))
                    }
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isProcessing)
                    
                    // Moving Issues (Input -> Node -> Output)
                    ForEach(issues) { issue in
                        IssueNode(isResolved: issue.isResolved)
                            .offset(x: issue.position)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                // Metrics Dashboard
                HStack(spacing: 30) {
                    MetricBox(title: "SUCCESS RATE", value: "70.6%", color: Color.green)
                    MetricBox(title: "TOTAL ISSUES", value: "\(totalAttempted)", color: Color.blue)
                    MetricBox(title: "RESOLVED", value: "\(processedCount)", color: Color.orange)
                }
                
                Spacer()
                
                // Bottom Legend
                Text("Simulating Specialized Domain Problem Solving...")
                    .font(.system(size: 12, weight: .semibold))
                    .kerning(1)
                    .foregroundColor(Color(hex: "#475569"))
                    .padding(.bottom, 20)
            }
        }
        .onReceive(timer) { _ in
            createNewIssue()
        }
    }
    
    private func createNewIssue() {
        let newIssue = Issue()
        issues.append(newIssue)
        totalAttempted += 1
        
        // Animate movement to node
        withAnimation(.linear(duration: 1.5)) {
            if let index = issues.firstIndex(where: { $0.id == newIssue.id }) {
                issues[index].position = 0 // Center Node
            }
        }
        
        // Process at node
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isProcessing = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isProcessing = false
                
                // Determine resolution (70.6% chance)
                let resolved = Double.random(in: 0...100) < 70.6
                if resolved { processedCount += 1 }
                
                if let index = issues.firstIndex(where: { $0.id == newIssue.id }) {
                    issues[index].isResolved = resolved
                    
                    // Move to output
                    withAnimation(.linear(duration: 1.5)) {
                        issues[index].position = 300
                    }
                }
                
                // Remove issue after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    issues.removeAll(where: { $0.id == newIssue.id })
                }
            }
        }
    }
}

struct IssueNode: View {
    var isResolved: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.2), lineWidth: 1))
            
            if isResolved {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 20))
            } else {
                Image(systemName: "doc.text.fill")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.system(size: 20))
            }
        }
    }
}

struct MetricBox: View {
    var title: String
    var value: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Color(hex: "#94a3b8"))
            Text(value)
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(color)
        }
        .frame(width: 100)
    }
}

struct AgenticWorkflowAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AgenticWorkflowAnimationView()
    }
}
