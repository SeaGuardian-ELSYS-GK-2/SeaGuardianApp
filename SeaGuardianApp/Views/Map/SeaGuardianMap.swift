import SwiftUI
import MapKit

enum AnnotationType: Identifiable, Equatable {
    case vessel(Vessel)
    case crewMember(CrewMember)

    var id: String {
        switch self {
        case .vessel(let vessel):
            return "vessel_\(vessel.id)"
        case .crewMember(let crewMember):
            return "crew_\(crewMember.id)"
        }
    }
    
    static func == (lhs: AnnotationType, rhs: AnnotationType) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SeaGuardianMap: View {
    @Environment(VesselsModel.self) var vessels
    @Binding var selectedAnnotation: AnnotationType?
    @Binding var focusedAnnotation: AnnotationType?
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        VStack {
            Map(position: $cameraPosition) {
                ForEach(vessels.vessels.values.sorted(by: { $0.id < $1.id })) { vessel in
                    Annotation("Vessel \(vessel.id)", coordinate: CLLocationCoordinate2D(latitude: vessel.latitude, longitude: vessel.longitude)) {
                        VesselAnnotationView(
                            vessel: vessel,
                            selectedAnnotation: $selectedAnnotation
                        )
                    }

                    ForEach(vessel.crew.values.filter { $0.overBoard }) { crewMember in
                        if let lat = crewMember.latitude, let lng = crewMember.longitude {
                            Annotation(crewMember.name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)) {
                                CrewMemberAnnotationView(
                                    crewMember: crewMember,
                                    selectedAnnotation: $selectedAnnotation
                                )
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
            .onChange(of: focusedAnnotation) {
                if let annotation = focusedAnnotation {
                    switch annotation {
                    case .vessel(let vessel):
                        let coordinate = CLLocationCoordinate2D(latitude: vessel.latitude, longitude: vessel.longitude)
                        cameraPosition = .region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 25000, longitudinalMeters: 25000))
                    case .crewMember(let crewMember):
                        if let lat = crewMember.latitude, let lng = crewMember.longitude {
                            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            cameraPosition = .region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    struct SeaGuardianMapPreviewWrapper: View {
        @State private var selectedAnnotation: AnnotationType? = nil
        @State private var focusedAnnotation: AnnotationType? = nil
        let vessels = VesselsModel.preview

        var body: some View {
            SeaGuardianMap(selectedAnnotation: $selectedAnnotation, focusedAnnotation: $focusedAnnotation)
                .environment(vessels)
        }
    }

    return SeaGuardianMapPreviewWrapper()
}
