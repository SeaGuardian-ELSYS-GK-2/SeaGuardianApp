import SwiftUI
import MapKit

struct ContentView: View {
    @State private var showingSettings = false
    @State private var isMenuOpen = true
    @State private var selectedAnnotation: AnnotationType? = nil
    @State private var selectedCrewMember: CrewMember? = nil
    
    var body: some View {
        ZStack(alignment: .leading) {
            NavigationStack {
                VStack {
                    SeaGuardianMap(selectedAnnotation: $selectedAnnotation)
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
                .sheet(isPresented: $showingSettings) {
                    SettingsHost()
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
                    selectedAnnotation = .crewMember(crewMember)
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
