import SwiftUI

@main
struct PersonalHealthTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            StitchMainFlowView()
                .preferredColorScheme(.dark)
        }
    }
}
