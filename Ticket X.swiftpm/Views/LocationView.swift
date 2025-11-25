import SwiftUI

// สร้าง Model ย่อยเพื่อเก็บข้อมูลให้ละเอียดขึ้น
struct CinemaLocation: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let distance: String
    let rating: Double
    let address: String
}

struct LocationView: View {
    
    // --- Data Source ---
    @State private var cinemas: [CinemaLocation] = [
        CinemaLocation(name: "Major Cineplex Central World", distance: "0.8 km", rating: 4.8, address: "7th Fl., Central World"),
        CinemaLocation(name: "SF World Cinema Central World", distance: "0.8 km", rating: 4.7, address: "8th Fl., Central World"),
        CinemaLocation(name: "Paragon Cineplex", distance: "1.2 km", rating: 4.9, address: "5th Fl., Siam Paragon"),
        CinemaLocation(name: "Quartier CineArt", distance: "5.5 km", rating: 4.6, address: "4th Fl., EmQuartier"),
        CinemaLocation(name: "Embassy Diplomat Screens", distance: "2.1 km", rating: 5.0, address: "6th Fl., Central Embassy")
    ]
    
    // --- State Management ---
    @State private var searchText: String = ""
    
    // --- Logic การค้นหา ---
    var filteredCinemas: [CinemaLocation] {
        if searchText.isEmpty {
            return cinemas
        } else {
            return cinemas.filter { cinema in
                cinema.name.lowercased().contains(searchText.lowercased()) ||
                cinema.address.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(colors: [.backgroundColor, .backgroundColor2],
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Header Area
                VStack(spacing: 20) {
                    Text("Cinemas Nearby")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.top, 20)
                    
                    // 2. Search Bar (สไตล์เดียวกับ CategoryView)
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                        
                        TextField("Search cinema or location...", text: $searchText)
                            .foregroundStyle(.white)
                            .autocorrectionDisabled()
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                withAnimation { searchText = "" }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: 600) // จำกัดความกว้างบน iPad
                }
                .padding(.bottom, 20)
                
                // 3. List Area
                ScrollView {
                    // กรณีค้นหาไม่เจอ
                    if filteredCinemas.isEmpty {
                        VStack(spacing: 15) {
                            Image(systemName: "mappin.slash.circle.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(.gray.opacity(0.5))
                                .padding(.top, 50)
                            Text("No cinemas found")
                                .font(.headline)
                                .foregroundStyle(.gray)
                        }
                    } else {
                        // รายการโรงหนัง
                        VStack(spacing: 15) {
                            ForEach(filteredCinemas, id: \.id) { cinema in
                                CinemaCard(cinema: cinema)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                        .animation(.spring(), value: filteredCinemas)
                    }
                }
            }
        }
    }
}

struct CinemaCard: View {
    let cinema: CinemaLocation
    
    let strokeColor = Color.white.opacity(0.1)
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.appPink, .appPurple], startPoint: .top, endPoint: .bottom))
                    .frame(width: 54, height: 54)
                    .shadow(color: .appPink.opacity(0.4), radius: 8, x: 0, y: 4)
                
                Image(systemName: "map.fill")
                    .foregroundStyle(.white)
                    .font(.system(size: 20))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(cinema.name)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text(cinema.address)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                HStack(spacing: 10) {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .foregroundStyle(SwiftUI.Color.appCyan)
                            .font(.caption2)
                        Text(cinema.distance)
                            .font(.caption2)
                            .foregroundStyle(SwiftUI.Color.appCyan)
                    }
                }
                .padding(.top, 2)
            }
            
            Spacer()
            
            // Navigate Button
            Button(action: {
                openGoogleMaps(query: cinema.name)
            }) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "location.north.fill") // เปลี่ยนไอคอนให้ดูเป็นนำทางมากขึ้น
                        .foregroundStyle(.white)
                        .font(.system(size: 18))
                }
            }
        }
        .padding(15)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(strokeColor, lineWidth: 1)
        )
    }
    
    // ย้ายฟังก์ชันเปิดแผนที่มาไว้ในนี้ หรือจะไว้ข้างนอกก็ได้
    func openGoogleMaps(query: String) {
        // ใช้ URL มาตรฐานของ Google Maps Web เพื่อความชัวร์
        let searchText = "\(query) Bangkok"
        if let encodedQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedQuery)") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}


#Preview {
    LocationView()
}
