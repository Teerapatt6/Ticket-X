import SwiftUI

struct CircleBackground: View {
    var color: Color
    var body: some View {
        Circle()
            .frame(width: 300, height: 300)
            .foregroundColor(color)
    }
}

struct CircleBackground_Previews: PreviewProvider {
    static var previews: some View {
        CircleBackground(color: .greenCircle)
    }
}

// #Preview {
//     CircleBackground()
// }




