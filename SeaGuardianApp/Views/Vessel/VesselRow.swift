import SwiftUI


struct VesselRowView: View {
    let vessel: Vessel
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
            
            if isExpanded {
                ForEach(Array(vessel.crew.values)) { crewMember in
                    CrewMemberRowView(crewMember: crewMember)
                }
            }
        }
    }
}


#Preview {
    if let vessel = VesselsModel.preview.vessels.first?.value {
        VesselRowView(vessel: vessel)
    } else {
        Text("No vessel available")
    }
}
