import SwiftUI


struct CoordDetail: View {
    let lat: Double
    let lng: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Lat: \(lat, specifier: "%.5f")")
                .font(.caption2)
            Text("Lng: \(lng, specifier: "%.5f")")
                .font(.caption2)
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .shadow(radius: 2)
        .frame(height: 80)
    }
}
