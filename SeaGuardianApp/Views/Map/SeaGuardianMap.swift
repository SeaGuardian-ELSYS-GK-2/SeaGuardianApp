import SwiftUI
import MapKit

struct SeaGuardianMap: View {
    @Environment(VesselsModel.self) var vessels
    @Binding var selectedVessel: Vessel?
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        VStack {
            Map(position: $cameraPosition) {
                ForEach(vessels.vessels.values.sorted(by: { $0.id < $1.id })) { vessel in
                    Annotation("Vessel \(vessel.id)", coordinate: CLLocationCoordinate2D(latitude: vessel.latitude, longitude: vessel.longitude)) {
                        VesselAnnotationView(
                            vessel: vessel,
                            isSelected: selectedVessel == vessel,
                            onTap: {
                                selectedVessel = (selectedVessel == vessel) ? nil : vessel
                            }
                        )
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
        .onChange(of: selectedVessel) {
            if let vessel = selectedVessel {
                let coordinate = CLLocationCoordinate2D(latitude: vessel.latitude, longitude: vessel.longitude)
                cameraPosition = .region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 25000, longitudinalMeters: 25000))
            }
        }
    }
}

#Preview {
    struct SeaGuardianMapPreviewWrapper: View {
        @State private var selectedVessel: Vessel? = nil
        let vessels = VesselsModel.preview

        var body: some View {
            SeaGuardianMap(selectedVessel: $selectedVessel)
                .environment(vessels)
        }
    }

    return SeaGuardianMapPreviewWrapper()
}
