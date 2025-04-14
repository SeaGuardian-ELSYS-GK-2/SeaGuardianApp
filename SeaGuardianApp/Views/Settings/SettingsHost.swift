import SwiftUI

struct SettingsHost: View {
    @Environment(\.editMode) var editMode
    @Environment(SettingsModel.self) var settingsModel

    @State private var draftSettings = SettingsModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel", role: .cancel) {
                        draftSettings = settingsModel.copy()
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
                        draftSettings = settingsModel.copy()
                    }
                    .onDisappear {
                        settingsModel.host = draftSettings.host
                        settingsModel.port = draftSettings.port
                    }
            }
        }
        .padding()
    }
}

#Preview {
    SettingsHost()
        .environment(SettingsModel())
}
