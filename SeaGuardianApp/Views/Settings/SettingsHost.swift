import SwiftUI

struct SettingsHost: View {
    @Environment(\.editMode) var editMode
    @Environment(SettingsModel.self) var settings
    @Environment(WebSocketManager.self) var webSocket

    @State private var draftSettings = SettingsModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel", role: .cancel) {
                        draftSettings = settings.copy()
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }

            if editMode?.wrappedValue == .inactive {
                SettingsSummary()
            } else {
                SettingsEditor(settings: draftSettings)
                    .onAppear {
                        draftSettings = settings.copy()
                    }
                    .onDisappear {
                        let settingsChanged = draftSettings != settings
                        
                        if settingsChanged {
                            settings.host = draftSettings.host
                            settings.port = draftSettings.port
                            webSocket.reconnect()
                        }
                    }
            }
        }
        .padding()
    }
}

#Preview {
    let settings = SettingsModel()
    let vessels = VesselsModel()
    let webSocket = WebSocketManager(settings: settings, vessels: vessels)
    SettingsHost()
        .environment(settings)
        .environment(webSocket)
}
