import SwiftUI


struct VesselSideMenu: View {
    var onVesselTap: (Vessel) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Vessels")
                .font(.title)
                .padding(.leading)
            
            VesselList(onVesselTap: onVesselTap)
            Spacer()
        }
        .frame(maxWidth: 300)
        .background(Color(UIColor.systemBackground))
    }
}


#Preview {
    VesselSideMenu(onVesselTap: { _ in })
        .environment(VesselsModel.preview)
}
