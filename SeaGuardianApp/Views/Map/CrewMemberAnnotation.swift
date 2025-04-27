import SwiftUI
import MapKit

struct CrewMemberAnnotationView: View {
    let crewMember: CrewMember
    @Binding var selectedAnnotation: AnnotationType?

    var isSelected: Bool {
        selectedAnnotation == .crewMember(crewMember)
    }

    var body: some View {
        ZStack {
            Button(action: {
                selectedAnnotation = isSelected ? nil : .crewMember(crewMember)
            }) {
                Image(systemName: "figure.pool.swim")
                    .resizable()
                    .frame(width: 44, height: 32)
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)

            if isSelected {
                CoordDetail(lat: crewMember.latitude!, lng: crewMember.longitude!)
                    .fixedSize()
                    .cornerRadius(8)
                    .shadow(radius: 3)
                    .offset(y: -60)
            }
        }
        .frame(width: 32, height: 32)
    }
}
