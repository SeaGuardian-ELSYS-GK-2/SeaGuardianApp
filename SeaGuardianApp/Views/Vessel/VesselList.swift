import SwiftUI

struct VesselList: View {
    @Environment(VesselsModel.self) var vesselsModel
    var onVesselTap: (Vessel) -> Void

    var body: some View {
        List {
            ForEach(vesselsModel.vessels.values.sorted(by: { $0.id < $1.id })) { vessel in
                VesselRowView(vessel: vessel)
            }
        }
        .navigationTitle("Vessels")
        .foregroundColor(.primary)
    }
}


#Preview {
    VesselList(onVesselTap: { _ in })
        .environment(VesselsModel.preview)
}
