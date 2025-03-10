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

            Map(position: $cameraPosition) {
                Marker("", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                MapCircle(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 20)
                    .foregroundStyle(.red.opacity(0.3))
            }
            .mapStyle(.standard)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .frame(height: 300)
            .cornerRadius(10)
            .padding()

            Text("Latitude: \(latitude, specifier: "%.6f")")
                .font(.headline)
                .foregroundColor(.blue)

            Text("Longitude: \(longitude, specifier: "%.6f")")
                .font(.headline)
                .foregroundColor(.red)
        }
        .onAppear {
            webSocketManager.connect()
            webSocketManager.onReceiveCoordinates = { lat, lng in
                self.latitude = lat
                self.longitude = lng
                self.cameraPosition = .region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                )
            }
        }
        .onDisappear {
            webSocketManager.disconnect()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
