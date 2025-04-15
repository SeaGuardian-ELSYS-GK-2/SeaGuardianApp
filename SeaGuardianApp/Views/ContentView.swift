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
    let vessels = VesselsModel()
    let webSocket = WebSocketManager(settings: settings, vessels: vessels)
    ContentView()
        .environment(settings)
        .environment(vessels)
        .environment(webSocket)
}
