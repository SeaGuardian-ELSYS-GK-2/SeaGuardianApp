import SwiftUI
import MapKit

struct ContentView: View {
    @State private var showingSettings = false
    @State private var isMenuOpen = true
    @State private var selectedVessel: Vessel? = nil
    @State private var selectedCrewMember: CrewMember? = nil
    
    var body: some View {
        ZStack(alignment: .leading) {
            NavigationStack {
                VStack {
                    SeaGuardianMap(selectedVessel: $selectedVessel)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation {
                                isMenuOpen.toggle()
                            }
                        } label: {
                            Image(systemName: "line.horizontal.3")
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

            VesselSideMenu(
                onVesselTap: { vessel in
                    selectedVessel = vessel
                },
                onClose: {
                    withAnimation {
                        isMenuOpen = false
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
