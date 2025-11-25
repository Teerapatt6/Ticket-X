import SwiftUI

struct CustomTabBar: View {
    
    @Binding var currentTab: Tab
    
    var backgroundColors = [Color.purple, Color.lightBlue, Color.pink]
    var gradientCircle = [Color.cyan, Color.cyan.opacity(0.1), Color.cyan]
    
    // ประกาศ circleSize ตรงนี้ เพื่อให้ทุกฟังก์ชันใน Struct มองเห็น
    let circleSize: CGFloat = 80
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    
                    Button {
                        withAnimation(.easeInOut) {
                            currentTab = tab
                        }
                    } label: {
                        VStack {
                            // ใช้ iconName function เพื่อเรียก SF Symbol
                            Image(systemName: iconName(for: tab))
                                .renderingMode(.template)
                                .font(.system(size: 22, weight: .bold)) // ปรับขนาดไอคอนให้ชัดขึ้น
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                            // ขยับไอคอนขึ้นเล็กน้อยเมื่อถูกเลือก
                                .offset(y: currentTab == tab ? -15 : 0)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            // ส่วนของวงกลม Indicator
            .background(alignment: .leading) {
                ZStack {
                    // วงกลมพื้นหลังโปร่งแสง
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: circleSize, height: circleSize)
                        .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                    
                    // วงกลมขอบสี (Stroke) หมุนๆ
                    Circle()
                        .trim(from: 0, to: 0.5)
                        .stroke(
                            LinearGradient(colors: gradientCircle, startPoint: .top, endPoint: .bottom),
                            style: StrokeStyle(lineWidth: 2)
                        )
                        .rotationEffect(.degrees(135))
                        .frame(width: circleSize - 2, height: circleSize - 2)
                }
                // ดันวงกลมขึ้นไปข้างบนเพื่อให้ลอยเหนือ TabBar
                .offset(y: -15)
                // คำนวณตำแหน่งแนวนอน
                .offset(x: indicatorOffset(width: width))
            }
        }
        .frame(height: 70) // ปรับความสูง TabBar ให้เหมาะสมกับนิ้ว
        .padding(.bottom, 10) // ดันขึ้นมาจากขอบล่างเล็กน้อย
        .background(.ultraThinMaterial)
        .background(
            LinearGradient(colors: backgroundColors, startPoint: .leading, endPoint: .trailing)
        )
    }
    
    func iconName(for tab: Tab) -> String {
        switch tab {
        case .home: return "house.fill"
        case .location: return "location.fill"
        case .ticket: return "ticket.fill"
        case .category: return "square.grid.2x2.fill"
        case .profile: return "person.fill"
        }
    }
    
    func indicatorOffset(width: CGFloat) -> CGFloat {
        let index = CGFloat(getIndex())
        
        let count = CGFloat(Tab.allCases.count)
        

        let buttonWidth = width / count
        
        // สูตร: (ตำแหน่งปุ่ม * กว้างปุ่ม) + (ครึ่งปุ่ม) - (ครึ่งวงกลม)
        // เพื่อให้จุดกึ่งกลางวงกลม ตรงกับ จุดกึ่งกลางปุ่มพอดี
        return (index * buttonWidth) + (buttonWidth / 2) - (circleSize / 2)
    }
    
    func getIndex() -> Int {
        switch currentTab {
        case .home: return 0
        case .location: return 1
        case .ticket: return 2
        case .category: return 3
        case .profile: return 4
        }
    }
}
