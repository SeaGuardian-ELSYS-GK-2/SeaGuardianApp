import SwiftUI

struct SettingsEditor: View {
    @Bindable var settings: SettingsModel

    var body: some View {
        List {
            HStack {
                Text("Host")
                Spacer()
                TextField("Host", text: $settings.host)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Port")
                Spacer()
                TextField("Port", value: $settings.port, format: .number)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

#Preview {
    SettingsEditor(settings: SettingsModel())
}
