import SwiftUI
import MapKit

struct ContentView: View {
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var cameraPosition: MapCameraPosition = .automatic

    private let webSocketManager = WebSocketManager()

    var body: some View {
        VStack {
            Text("Live Coordinates")
                .font(.title)
                .padding()

            SeaGuardianMap()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
