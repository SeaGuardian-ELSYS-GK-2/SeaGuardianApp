import SwiftUI


struct SideMenu: View {
    var onVesselTap: (Vessel) -> Void
    var onClose: () -> Void
    var onCrewListRowTap: (CrewMember) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Crew Members")
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

            CrewList(onRowTap: onCrewListRowTap)
            Spacer()
        }
        .frame(maxWidth: 300)
        .background(Color(UIColor.systemBackground))
    }
}


#Preview {
    SideMenu(onVesselTap: { _ in }, onClose: {}, onCrewListRowTap: { _ in })
        .environment(VesselsModel.preview)
}
