import SwiftUI
import MapKit

struct SeaGuardianMap: View {
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        VStack {
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
    }
}

struct SeaGuardianMap_Previews: PreviewProvider {
    static var previews: some View {
        SeaGuardianMap()
    }
}
