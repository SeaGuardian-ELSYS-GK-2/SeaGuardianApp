import SwiftUI

struct CrewMemberRow: View {
    @Bindable var crewMember: CrewMember
    var onTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            if let base64 = crewMember.imgBase64,
               let image = decodeBase64Image(base64) {
                CircularImage(image: image)
            } else {
                CircularImage(image: Image(systemName: "person.crop.circle.fill"))
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                     Text(crewMember.name)
                        .font(.title3)
                        .bold()
                    
                    Spacer()

                    if crewMember.overBoard {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                            .imageScale(.large)
                    }
                }
                

                if crewMember.overBoard,
                   let lat = crewMember.latitude,
                   let lng = crewMember.longitude {
                    Text(String(format: "(%.5f, %.5f)", lat, lng))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }

        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }

    func decodeBase64Image(_ base64: String) -> Image? {
        if let data = Data(base64Encoded: base64),
           let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}
