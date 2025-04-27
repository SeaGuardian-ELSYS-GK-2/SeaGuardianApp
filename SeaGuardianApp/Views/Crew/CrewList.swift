import SwiftUI

struct CrewList: View {
    @Environment(VesselsModel.self) var vesselsModel
    @State private var showOnlyOverboard = false
    var onRowTap: (CrewMember) -> Void

    var sortedVessels: [Vessel] {
        vesselsModel.vessels.values
            .filter { vessel in
                !showOnlyOverboard || vessel.crew.values.contains { $0.overBoard }
            }
            .sorted(by: { $0.id < $1.id })
    }

    func sortedCrew(for vessel: Vessel) -> [CrewMember] {
        vessel.crew.values
            .sorted(by: { $0.id < $1.id })
            .filter { !showOnlyOverboard || $0.overBoard }
    }

    var body: some View {
        VStack {
            Toggle("Show only overboard", isOn: $showOnlyOverboard)
                .padding(.horizontal)
                .onChange(of: showOnlyOverboard) {
                    withAnimation(.easeInOut(duration: 0.3)) {}
                }

            List {
                if showOnlyOverboard && sortedVessels.isEmpty {
                    Text("No crew members are overboard 🎉")
                        .foregroundStyle(.secondary)
                        .transition(.opacity)
                } else {
                    ForEach(sortedVessels) { vessel in
                        Section(header: Text("Vessel \(vessel.id)")) {
                            let crewList = sortedCrew(for: vessel)
                            ForEach(crewList) { crewMember in
                                CrewMemberRow(crewMember: crewMember) {
                                    onRowTap(crewMember)
                                }
                                .transition(.opacity)
                            }
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: sortedVessels)
        }
    }
}

#Preview {
    CrewList(onRowTap: { _ in })
        .environment(VesselsModel.preview)
        .frame(maxWidth: 320)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
}
