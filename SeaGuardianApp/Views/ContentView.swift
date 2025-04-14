import SwiftUI
import MapKit

struct ContentView: View {
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var showingSettings = false

    @State private var settings = SettingsModel()

    private let webSocketManager = WebSocketManager()

    var body: some View {
        NavigationStack {
            VStack {
                Text("Live Coordinates")
                    .font(.title)
                    .padding()

                SeaGuardianMap()
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
                    .environment(settings)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
