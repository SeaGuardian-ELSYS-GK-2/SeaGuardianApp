import SwiftUI


struct VesselSideMenu: View {
    var onVesselTap: (Vessel) -> Void
    var onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Vessels")
                    .font(.title)
                    .padding(.leading, 16)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .padding(.trailing, 16)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 8)

            VesselList(onVesselTap: onVesselTap)
            Spacer()
        }
        .frame(maxWidth: 300)
        .background(Color(UIColor.systemBackground))
    }
}


#Preview {
    VesselSideMenu(onVesselTap: { _ in }, onClose: {})
        .environment(VesselsModel.preview)
}
