import SwiftUI
import MapKit

struct ContentView: View {
    @State private var showingSettings = false


    var body: some View {
        NavigationStack {
            VStack {
                Text("Live Coordinates")
                    .font(.title)
                    .padding()

            }
            .navigationTitle("SeaGuardian")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsHost()
            }
        }
    }
}

#Preview {
    let settings = SettingsModel()
    let webSocket = WebSocketManager(settings: settings)
    return ContentView()
        .environment(settings)
        .environment(webSocket)
}
