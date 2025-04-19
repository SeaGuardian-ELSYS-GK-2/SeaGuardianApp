import SwiftUI
import MapKit

struct SeaGuardianMap: View {
    @Environment(VesselsModel.self) var vessels
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        VStack {
            Map(position: $cameraPosition) {
                ForEach(vessels.vessels.values.sorted(by: { $0.id < $1.id })) { vessel in
                    Annotation("Vessel \(vessel.id)", coordinate: CLLocationCoordinate2D(latitude: vessel.latitude, longitude: vessel.longitude)) {
                        Image(systemName: "ferry.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }

                    ForEach(vessel.crew.values.filter { $0.overBoard }) { crew in
                        if let lat = crew.latitude, let lng = crew.longitude {
                            Annotation(crew.name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)) {
                                VStack {
                                    Image(systemName: "figure.pool.swim")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
            }
            .mapStyle(.standard)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
        }
    }
}

#Preview {
    let vessels = VesselsModel.preview
    SeaGuardianMap()
        .environment(vessels)
}
