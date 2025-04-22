import SwiftUI


struct VesselDetailView: View {
    let vessel: Vessel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Vessel \(vessel.id)")
                .font(.caption)
                .bold()
            Text("Lat: \(vessel.latitude, specifier: "%.4f")")
                .font(.caption2)
            Text("Lng: \(vessel.longitude, specifier: "%.4f")")
                .font(.caption2)
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .shadow(radius: 2)
        .frame(height: 80)
    }
}


#Preview {
    if let vessel = VesselsModel.preview.vessels.first?.value {
        VesselDetailView(vessel: vessel)
    } else {
        Text("No vessel available")
    }
}
