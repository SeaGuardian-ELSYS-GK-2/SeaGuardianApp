import SwiftUI
import MapKit

enum AnnotationType: Identifiable, Equatable {
    case vessel(Vessel)
    case crew(CrewMember)

    var id: String {
        switch self {
        case .vessel(let vessel):
            return "vessel_\(vessel.id)"
        case .crew(let crew):
            return "crew_\(crew.id)"
        }
    }
    
    static func == (lhs: AnnotationType, rhs: AnnotationType) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SeaGuardianMap: View {
    @Environment(VesselsModel.self) var vessels
    @Binding var selectedAnnotation: AnnotationType?
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
        }
    }
}

#Preview {
    struct SeaGuardianMapPreviewWrapper: View {
        @State private var selectedAnnotation: AnnotationType? = nil
        let vessels = VesselsModel.preview

        var body: some View {
            SeaGuardianMap(selectedAnnotation: $selectedAnnotation)
                .environment(vessels)
        }
    }

    return SeaGuardianMapPreviewWrapper()
}
