import SwiftUI


struct VesselCrewMemberRow: View {
    var crewMember: CrewMember
    
    var body: some View {
        VStack {
            HStack {
                Text("\(crewMember.name)")
                if crewMember.overBoard {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                }
                Spacer()
            }
            if crewMember.overBoard, let lat = crewMember.latitude, let lng = crewMember.longitude {
                HStack {
                    Text("\(lat, specifier: "%.4f"), \(lng, specifier: "%.4f")")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                
            }
        }
        
    }
    
}
