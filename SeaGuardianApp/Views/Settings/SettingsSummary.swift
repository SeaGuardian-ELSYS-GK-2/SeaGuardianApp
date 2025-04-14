import SwiftUI

struct SettingsSummary: View {
    @Environment(SettingsModel.self) var settings

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                settingRow(label: "host", value: settings.host)
                settingRow(label: "port", value: "\(settings.port)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }

    @ViewBuilder
    private func settingRow(label: String, value: String) -> some View {
        Text("\(label): ") +
        Text(value).foregroundStyle(.secondary)
    }
}

#Preview {
    SettingsSummary()
        .environment(SettingsModel())
}
