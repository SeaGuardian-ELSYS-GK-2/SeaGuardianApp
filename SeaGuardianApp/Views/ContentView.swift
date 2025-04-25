import SwiftUI
import MapKit


struct ContentView: View {
    @Environment(VesselsModel.self) var vesselsModel
    @State private var showingSettings = false
    @State private var isMenuOpen = true
    @State private var selectedAnnotation: AnnotationType? = nil
    @State private var focusedAnnotation: AnnotationType? = nil
    @State private var selectedCrewMember: CrewMember? = nil
    
    func findVessel(for crewMember: CrewMember) -> Vessel? {
        for vessel in vesselsModel.vessels.values {
            if vessel.crew.keys.contains(crewMember.id) {
                return vessel
            }
        }
        return nil
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            NavigationStack {
                VStack {
                    SeaGuardianMap(selectedAnnotation: $selectedAnnotation, focusedAnnotation: $focusedAnnotation)
                }
                .sheet(isPresented: $showingSettings) {
                    SettingsHost()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            isMenuOpen.toggle()
                        }
                    } label: {
                        Image(systemName: "sidebar.left")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }

            SideMenu(
                onVesselTap: { vessel in
                    selectedAnnotation = .vessel(vessel)
                },
                onClose: {
                    withAnimation {
                        isMenuOpen = false
                    }
                },
                onCrewListRowTap: { crewMember in
                    if crewMember.overBoard {
                        focusedAnnotation = .crewMember(crewMember)
                    } else {
                        if let vessel = findVessel(for: crewMember) {
                            focusedAnnotation = .vessel(vessel)
                        }
                    }
                }
            )
            .frame(width: 300)
            .offset(x: isMenuOpen ? 0 : -300)
            .animation(.easeInOut(duration: 0.25), value: isMenuOpen)
        }
    }
}

#Preview {
    let settings = SettingsModel()
//    let vessels = VesselsModel()
    let vessels = VesselsModel.preview
    let webSocket = WebSocketManager(settings: settings, vessels: vessels)
    ContentView()
        .environment(settings)
        .environment(vessels)
        .environment(webSocket)
}
