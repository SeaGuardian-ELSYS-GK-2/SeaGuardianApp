import SwiftUI


struct VesselSideMenu: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Vessels")
                .font(.title)
            
            VesselList()
            Spacer()
        }
        .frame(maxWidth: 300)
        .background(Color(UIColor.systemBackground))
    }
}


#Preview {
    VesselSideMenu()
        .environment(VesselsModel.preview)
}
