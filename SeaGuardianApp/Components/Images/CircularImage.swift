import SwiftUI

struct CircularImage: View {
    let image: Image
    let size: CGFloat = 64

    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white.opacity(0.6), lineWidth: 2))
            .shadow(radius: 4)
    }
}
