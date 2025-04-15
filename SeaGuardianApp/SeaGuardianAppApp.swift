import SwiftUI

@main
struct SeaGuardianAppApp: App {
    let settings: SettingsModel
    let vessels: VesselsModel
    let webSocket: WebSocketManager
    
    init() {
        self.settings = SettingsModel()
        self.vessels = VesselsModel()
        self.webSocket = WebSocketManager(settings: settings, vessels: vessels)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settings)
                .environment(vessels)
                .environment(webSocket)
        }
    }
}
