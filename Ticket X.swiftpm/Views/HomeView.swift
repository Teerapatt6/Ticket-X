import SwiftUI

struct HomeView: View {
    
    // --- Data Source ---
    @State var posters1: [String] = ["poster1", "poster2", "poster3", "poster4", "poster5", "poster6"]
    @State var posters2: [String] = ["poster7", "poster8", "poster9", "poster10", "poster11", "poster12"]
    @State var posters3: [String] = ["poster13", "poster14", "poster15", "poster16", "poster17", "poster18"]
    
    // --- State Management ---
    @State private var animate: Bool = false
    @State private var currentPromoIndex = 0
    
    // Timer สำหรับ Auto Slider (เลื่อนทุก 3 วินาที)
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // 1. Dynamic Background
            ZStack {
                LinearGradient(colors: [.backgroundColor, .backgroundColor2],
                               startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
                // Animated Circles
                CircleBackground(color: .greenCircle)
                    .blur(radius: animate ? 30 : 100)
                    .offset(x: animate ? -50 : -130, y: animate ? -30 : -100)
                
                CircleBackground(color: .pinkCircle)
                    .blur(radius: animate ? 30 : 100)
                    .offset(x: animate ? 100 : 130, y: animate ? 150 : 100)
            }
            .task {
                withAnimation(.easeInOut(duration: 7).repeatForever()) {
                    animate.toggle()
                }
            }
            
            // 2. Main Content
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Welcome Back 👋")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text("Choose Movie")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    
                    NavigationLink {
                        ProfileView() // ปลายทางเมื่อกดรูป
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.largeTitle)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                // Content ScrollView
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 35) { // เพิ่มระยะห่างให้ดูไม่อึดอัด
                        
                        // A. Promo Slider
                        PromoSlider(currentPromoIndex: $currentPromoIndex)
                        
                        // B. Movie Sections
                        VStack(spacing: 30) {
                            MovieSection(title: "Now Playing", movies: posters1)
                            MovieSection(title: "Coming Soon", movies: posters2)
                            MovieSection(title: "Top Rated", movies: posters3)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        // Auto Slide Logic
        .onReceive(timer) { _ in
            withAnimation {
                currentPromoIndex = (currentPromoIndex + 1) % 3
            }
        }
    }
}

// MARK: - Subviews

struct PromoSlider: View {
    @Binding var currentPromoIndex: Int
    let promos = ["poster13", "poster8", "poster5"]
    
    var body: some View {
        TabView(selection: $currentPromoIndex) {
            ForEach(0..<promos.count, id: \.self) { index in
                NavigationLink {
                    BookingView()
                } label: {
                    ZStack(alignment: .bottomLeading) {
                        Image(promos[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 260) // ปรับความสูงให้ดู Cinematic บน iPad
                            .frame(maxWidth: .infinity)
                            .overlay(
                                LinearGradient(colors: [.clear, .backgroundColor], startPoint: .top, endPoint: .bottom)
                            )
                            .cornerRadius(20)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Recommended")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.appPink) // ใช้สี Theme
                                .cornerRadius(5)
                                .foregroundStyle(.white)
                            
                            Text("Must Watch Movie #\(index + 1)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .shadow(radius: 5)
                        }
                        .padding(20)
                    }
                }
                .tag(index)
                .padding(.horizontal, 20)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 260)
    }
}

struct MovieSection: View {
    var title: String
    var movies: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(movies, id: \.self) { movie in
                        NavigationLink {
                            BookingView()
                        } label: {
                            MovieCard(imageName: movie)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct MovieCard: View {
    var imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 240) // ขนาดโปสเตอร์มาตรฐาน iPad
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
            
            Text("Movie Title")
                .font(.headline)
                .foregroundStyle(.white)
                .lineLimit(1)
                .frame(width: 160, alignment: .leading)
            
            // เพิ่มดาวเรตติ้งเล็กๆ ให้ดูมีรายละเอียด
            HStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                }
            }
        }
        .buttonStyle(PlainButtonStyle()) // ป้องกันแสงกระพริบเวลากดใน List
    }
}

#Preview {
    HomeView()
}
