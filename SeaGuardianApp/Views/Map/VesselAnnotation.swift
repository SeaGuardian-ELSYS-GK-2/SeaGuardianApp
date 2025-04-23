import SwiftUI
import MapKit

struct VesselAnnotationView: View {
    let vessel: Vessel
    @Binding var selectedAnnotation: AnnotationType?
    
    var isSelected: Bool {
        selectedAnnotation == .vessel(vessel)
    }

    var body: some View {
        ZStack {
            Button(action: {
                selectedAnnotation = isSelected ? nil : .vessel(vessel)
            }) {
                Image(systemName: "ferry.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)

            if isSelected {
                CoordDetail(lat: vessel.latitude, lng: vessel.longitude)
                    .fixedSize()
                    .cornerRadius(8)
                    .shadow(radius: 3)
                    .offset(y: -60)
            }
        }
        .frame(width: 32, height: 32)
    }
}
