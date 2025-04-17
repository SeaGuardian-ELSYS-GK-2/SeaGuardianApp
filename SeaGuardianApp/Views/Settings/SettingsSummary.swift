import SwiftUI

struct SettingsSummary: View {
    @Environment(SettingsModel.self) var settings
    @Environment(WebSocketManager.self) var webSocket

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                settingRow(label: "host", value: settings.host)
                settingRow(label: "port", value: "\(settings.port)")
                settingRow(label: "status", value: connectionStatusText)

                if case .disconnected = webSocket.connectionState {
                    Button("Connect") {
                        webSocket.connect()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }

                if case .connected = webSocket.connectionState {
                    Button("Disconnect") {
                        webSocket.disconnect()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
                
                if isConnectionFailed {
                    Button("Try Again") {
                        webSocket.connect()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .alert("Connection Error", isPresented: .constant(isConnectionFailed)) {
            Button("OK", role: .cancel) {}
        } message: {
            if case .failed(let reason) = webSocket.connectionState {
                Text(reason)
            } else {
                Text("Unknown error")
            }
        }
    }

    private var connectionStatusText: String {
        switch webSocket.connectionState {
        case .disconnected:
            return "🔴 Disconnected"
        case .connecting:
            return "🟡 Connecting..."
        case .connected:
            return "🟢 Connected"
        case .failed:
            return "🔴 Failed"
        }
    }

    private var isConnectionFailed: Bool {
        if case .failed = webSocket.connectionState {
            return true
        }
        return false
    }

    @ViewBuilder
    private func settingRow(label: String, value: String) -> some View {
        Text("\(label): ") +
        Text(value).foregroundStyle(.secondary)
    }
}
