import SwiftUI

struct SettingsSummary: View {
    @Environment(SettingsModel.self) var settings
    @Environment(WebSocketManager.self) var webSocket
    
    @State private var showingError = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                settingRow(label: "host", value: settings.host)
                settingRow(label: "port", value: "\(settings.port)")
                settingRow(label: "status", value: webSocket.isConnected ? "🟢 Connected" : "🔴 Disconnected")

                if !webSocket.isConnected {
                    Button("Connect") {
                        webSocket.connect()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
                else {
                    Button("Disconnect") {
                        webSocket.disconnect()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .onChange(of: webSocket.errorMessage) {
            if !webSocket.didDisconnectManually {
                showingError = webSocket.errorMessage != nil
            }
        }
        .alert("Connection Error", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(webSocket.errorMessage ?? "Unknown error")
        }
    }

    @ViewBuilder
    private func settingRow(label: String, value: String) -> some View {
        Text("\(label): ") +
        Text(value).foregroundStyle(.secondary)
    }
}

#Preview {
    let settings = SettingsModel()
    let webSocket = WebSocketManager(settings: settings)
    return SettingsSummary()
        .environment(settings)
        .environment(webSocket)
}
