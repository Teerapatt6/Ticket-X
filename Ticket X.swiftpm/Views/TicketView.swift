import SwiftUI

struct TicketView: View {
    
    @State var animate: Bool = false
    
    var body: some View {
        ZStack {
            // Background Animation Loops
            CircleBackground(color: .greenCircle)
                .blur(radius: animate ? 30 : 100)
                .offset(x: animate ? -50 : -130, y: animate ? -30 : -100)
                .task {
                    withAnimation(.easeInOut(duration: 7).repeatForever()) {
                        animate.toggle()
                    }
                }
            
            CircleBackground(color: .pinkCircle)
                .blur(radius: animate ? 30 : 100)
                .offset(x: animate ? 100 : 130, y: animate ? 150 : 100)
            
            // Content
            VStack(spacing: 30) {
                Text("Mobile Ticket")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                // แก้ไขข้อความที่มีปัญหา U+00AD ให้เป็น Space ปกติ
                // และแก้คำผิด acces -> access
                Text("Once you buy a movie ticket simply scan the barcode to access to your movie.")
                    .frame(maxWidth: 300) // ขยายความกว้างให้อ่านง่ายบน iPad
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            // Ticket Card Component
            Tickets()
                .padding(.top, 50)
        }
        .background (
            LinearGradient(gradient: Gradient(colors: [.backgroundColor, .backgroundColor2]),
                           startPoint: .top, endPoint: .bottom)
        )
    }
}

#Preview {
    TicketView()
}
