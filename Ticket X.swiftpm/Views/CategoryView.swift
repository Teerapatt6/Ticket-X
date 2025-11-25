import SwiftUI

// --- Data Model for Category ---
struct GenreModel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let description: String
    var isFavorite: Bool = false
    var popularity: Int // สำหรับใช้ Sorting
}

struct CategoryView: View {
    
    // --- Data Source ---
    @State private var genres: [GenreModel] = [
        GenreModel(name: "Action", icon: "flame.fill", color: .red, description: "Explosions & Fights", popularity: 95),
        GenreModel(name: "Comedy", icon: "face.smiling.fill", color: .yellow, description: "Laugh out loud", popularity: 88),
        GenreModel(name: "Romance", icon: "heart.fill", color: .appPink, description: "Love is in the air", popularity: 75),
        GenreModel(name: "Sci-Fi", icon: "star.fill", color: .appCyan, description: "Space & Future", popularity: 92),
        GenreModel(name: "Horror", icon: "eye.fill", color: .purple, description: "Scary & Spooky", popularity: 60),
        GenreModel(name: "Drama", icon: "theatermasks.fill", color: .blue, description: "Emotional stories", popularity: 80),
        GenreModel(name: "Fantasy", icon: "wand.and.stars", color: .indigo, description: "Magic worlds", popularity: 85),
        GenreModel(name: "Animation", icon: "play.tv.fill", color: .orange, description: "For all ages", popularity: 90)
    ]
    
    // --- State Management ---
    @State private var searchText: String = ""
    @State private var sortOption: SortOption = .default
    @State private var showFavoritesOnly: Bool = false
    
    // --- Grid Layout (Responsive for iPad) ---
    // ใช้ adaptive เพื่อให้จำนวนคอลัมน์ปรับตามขนาดหน้าจออัตโนมัติ (iPad จะแสดงหลายคอลัมน์กว่า iPhone)
    let columns = [
        GridItem(.adaptive(minimum: 160, maximum: 250), spacing: 20)
    ]
    
    // --- Enum for Sorting ---
    enum SortOption {
        case `default`, name, popularity
    }
    
    // --- Computed Properties ---
    var filteredGenres: [GenreModel] {
        var result = genres
        
        // 1. Filter by Search
        if !searchText.isEmpty {
            result = result.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        // 2. Filter by Favorites
        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }
        
        // 3. Sorting
        switch sortOption {
        case .name:
            result.sort { $0.name < $1.name }
        case .popularity:
            result.sort { $0.popularity > $1.popularity }
        case .default:
            break
        }
        
        return result
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(colors: [.backgroundColor, .backgroundColor2],
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // 1. Header & Search Area
                VStack(spacing: 20) {
                    HStack {
                        Text("Discover")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                        
                        // Sort Menu
                        Menu {
                            Picker("Sort By", selection: $sortOption) {
                                Label("Default", systemImage: "line.3.horizontal.decrease").tag(SortOption.default)
                                Label("Name (A-Z)", systemImage: "textformat").tag(SortOption.name)
                                Label("Popularity", systemImage: "arrow.up.right").tag(SortOption.popularity)
                            }
                            
                            Toggle(isOn: $showFavoritesOnly) {
                                Label("Favorites Only", systemImage: "heart.fill")
                            }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                        TextField("Search genres...", text: $searchText)
                            .foregroundStyle(.white)
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill").foregroundStyle(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: 600) // จำกัดความกว้างบน iPad ไม่ให้ยาวเกินไป
                }
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        // 2. Banner Promotion (Top Recommendations)
                        if searchText.isEmpty && !showFavoritesOnly {
                            CategoryPromoBanner()
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        
                        // 3. Main Grid
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(filteredGenres, id: \.id) { genre in
                                NavigationLink {
                                    // Navigate to Genre Detail
                                    GenreDetailView(genre: genre)
                                } label: {
                                    CategoryCard(genre: genre) {
                                        // Handle toggle favorite logic
                                        if let index = genres.firstIndex(where: { $0.id == genre.id }) {
                                            withAnimation(.spring()) {
                                                genres[index].isFavorite.toggle()
                                            }
                                        }
                                    }
                                }
                                .buttonStyle(BouncyButtonStyle()) // Custom Animation
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                        .animation(.spring(), value: filteredGenres)
                    }
                }
            }
        }
    }
}

// MARK: - Subviews & Components

// 1. Category Card (Interactive & Themed)
struct CategoryCard: View {
    let genre: GenreModel
    var onFavoriteToggle: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Dynamic Background based on Genre Color
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [genre.color.opacity(0.8), genre.color.opacity(0.3), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
            
            // Content
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 40, height: 40)
                        Image(systemName: genre.icon)
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    
                    if genre.isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                            .shadow(color: .red.opacity(0.5), radius: 5)
                    }
                }
                
                Spacer()
                
                Text(genre.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text(genre.description)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
            }
            .padding(15)
        }
        .frame(height: 140)
        // Context Menu for Long Press
        .contextMenu {
            Button {
                onFavoriteToggle()
            } label: {
                Label(genre.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                      systemImage: genre.isFavorite ? "heart.slash" : "heart")
            }
            
            NavigationLink {
                GenreDetailView(genre: genre)
            } label: {
                Label("Explore \(genre.name)", systemImage: "arrow.right.circle")
            }
        }
    }
}

// 2. Banner Promotion
struct CategoryPromoBanner: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(0..<3, id: \.self) { index in
                    ZStack(alignment: .bottomLeading) {
                        Image("poster\(index + 13)") // ใช้ Mock Data ที่มี
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 160)
                            .overlay(LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom))
                            .cornerRadius(20)
                        
                        VStack(alignment: .leading) {
                            Text("Trending in Sci-Fi")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(5)
                                .background(Color.appCyan)
                                .cornerRadius(5)
                                .foregroundStyle(.black)
                            
                            Text("Must Watch This Week")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        .padding(15)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// 3. Genre Detail View (หน้าแสดงรายการหนังเมื่อกดหมวดหมู่)
struct GenreDetailView: View {
    let genre: GenreModel
    @Environment(\.dismiss) var dismiss
    
    // Mock Movies for the genre
    let movies = ["poster1", "poster5", "poster9", "poster12", "poster3", "poster7"]
    
    let columns = [GridItem(.adaptive(minimum: 150), spacing: 20)]
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    ZStack {
                        LinearGradient(colors: [genre.color.opacity(0.6), .clear], startPoint: .top, endPoint: .bottom)
                            .frame(height: 250)
                            .ignoresSafeArea()
                        
                        VStack {
                            Image(systemName: genre.icon)
                                .font(.system(size: 60))
                                .foregroundStyle(.white)
                                .shadow(radius: 10)
                            Text(genre.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Text("Top rated movies in \(genre.name)")
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    
                    // Movie Grid
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(movies, id: \.self) { movie in
                            NavigationLink {
                                BookingView()
                            } label: {
                                MovieCard(imageName: movie) // Reuse component from HomeView
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .foregroundStyle(.white)
                        .font(.title2)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// 4. Custom Button Style for Bouncy Effect
struct BouncyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    NavigationStack {
        CategoryView()
    }
}
