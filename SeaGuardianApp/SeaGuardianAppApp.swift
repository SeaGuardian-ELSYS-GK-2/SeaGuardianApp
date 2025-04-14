import SwiftUI

@main
struct SeaGuardianAppApp: App {
    let settings: SettingsModel
    let webSocket: WebSocketManager
    
    init() {
        self.settings = SettingsModel()
        self.webSocket = WebSocketManager(settings: settings)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settings)
                .environment(webSocket)
        }
    }
}
