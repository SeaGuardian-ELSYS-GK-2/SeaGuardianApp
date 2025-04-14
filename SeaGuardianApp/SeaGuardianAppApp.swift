import SwiftUI

@main
struct SeaGuardianAppApp: App {
    var settings = SettingsModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settings)
        }
    }
}
