import SwiftUI
import MapKit

struct VesselAnnotationView: View {
    let vessel: Vessel
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 4) {
//            if isSelected {
//                VesselDetailView(vessel: vessel)
//            }
//            else {
//                // Invisible box to reserve space
//                Rectangle()
//                    .fill(Color.clear)
//                    .frame(height: 80) // match expected height of VesselDetailView
//            }

            Button(action: onTap) {
                Image(systemName: "ferry.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .foregroundStyle(.primary)
        }
    }
}
