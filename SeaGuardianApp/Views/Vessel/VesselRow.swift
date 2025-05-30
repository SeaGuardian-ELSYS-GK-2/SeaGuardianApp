import SwiftUI


struct VesselRowView: View {
    let vessel: Vessel
    @State private var isExpanded = false
    var onVesselTap: (Vessel) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {onVesselTap(vessel)}) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Vessel ID: \(vessel.id)")
                            .font(.headline)
                        Text("\(vessel.latitude, specifier: "%.4f"), \(vessel.longitude, specifier: "%.4f")")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button(action: {
                        isExpanded.toggle()
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .imageScale(.large)
                    }
                    .buttonStyle(.plain)
                }
            }

            if isExpanded {
                ForEach(Array(vessel.crew.values)) { crewMember in
                    Divider()
                    VesselCrewMemberRow(crewMember: crewMember)
                }
                .padding(.leading)
            }
        }
    }
}


#Preview {
    if let vessel = VesselsModel.preview.vessels.first?.value {
        VesselRowView(vessel: vessel, onVesselTap: { _ in })
    } else {
        Text("No vessel available")
    }
}
