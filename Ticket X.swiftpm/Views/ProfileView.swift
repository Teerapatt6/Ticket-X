import SwiftUI

struct ProfileView: View {
    
    // --- State สำหรับข้อมูลผู้ใช้ ---
    @State private var username: String = "Movie Lover"
    @State private var bio: String = "Sci-Fi & Action Addict 🎬"
    @State private var memberSince: String = "Member since 2025"
    
    // --- State สำหรับ Mock Data ---
    @State private var ticketCount: Int = 5
    
    // แก้ไขการประกาศ Array ให้ชัดเจน
    @State private var paymentMethods: [String] = [
        "**** **** **** 4242",
        "**** **** **** 1234"
    ]
    
    // --- State สำหรับการควบคุม Sheet ---
    @State private var showEditProfile: Bool = false
    @State private var showTickets: Bool = false
    
    var body: some View {
        ZStack {
            // 1. พื้นหลัง Gradient
            LinearGradient(colors: [.backgroundColor, .backgroundColor2],
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    // 2. ส่วนหัวโปรไฟล์
                    Button {
                        showEditProfile = true
                    } label: {
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [.appCyan, .blue], startPoint: .top, endPoint: .bottom))
                                    .frame(width: 105, height: 105)
                                    .shadow(color: .appCyan.opacity(0.5), radius: 10, x: 0, y: 5)
                                
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundStyle(.white)
                                
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.white)
                                    .background(Circle().fill(Color.appPink))
                                    .offset(x: 35, y: 35)
                            }
                            
                            VStack(spacing: 5) {
                                Text(username)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                
                                Text(bio)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.appCyan)
                                
                                Text(memberSince)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    .padding(.top, 40)
                    
                    // 3. ส่วนสถิติ
                    HStack(spacing: 40) {
                        StatView(value: "\(ticketCount)", title: "Tickets")
                        StatView(value: "5", title: "Reviews")
                        StatView(value: "240", title: "Points")
                    }
                    .padding(.vertical, 10)
                    
                    // 4. เมนูต่างๆ (ปรับปรุงใหม่ตามสั่ง)
                    VStack(spacing: 15) {
                        // My Tickets
                        Button {
                            showTickets = true
                        } label: {
                            GlassMenuRow(icon: "ticket.fill", title: "My Tickets", subTitle: "\(ticketCount) active")
                        }
                        
                        // Payment Methods
                        NavigationLink {
                            PaymentMethodsView(methods: $paymentMethods)
                        } label: {
                            GlassMenuRow(icon: "creditcard.fill", title: "Payment Methods", subTitle: "Manage cards")
                        }
                        
                        // Reviews (มาแทน Help Center และ Settings)
                        NavigationLink {
                            ReviewsView() // ลิงก์ไปหน้าใหม่
                        } label: {
                            GlassMenuRow(icon: "star.bubble.fill", title: "Reviews", subTitle: "See your past reviews")
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // 5. ปุ่ม Logout (โชว์เฉยๆ กดไม่ได้)
                    // เปลี่ยนจาก Button เป็น Text ใน Container ธรรมดา
                    HStack {
                        Spacer()
                        Text("Log Out")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding()
                    .background(
                        LinearGradient(colors: [.appPink, .red], startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(15)
                    .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 5)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .opacity(0.8) // ลดความเข้มลงนิดหน่อยให้รู้ว่าเป็นสถานะ Visual
                    
                }
                .padding(.bottom, 100)
            }
        }
        .tint(Color.appPink)
        
        // --- Modals & Sheets ---
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(username: $username, bio: $bio)
                .presentationDetents([.medium])
        }
        .fullScreenCover(isPresented: $showTickets) {
            MyTicketsView(ticketCount: ticketCount)
        }
    }
}

// MARK: - New View: ReviewsView (หน้ารีวิวใหม่)
struct ReviewsView: View {
    // Mock Data สำหรับรีวิว
    struct Review: Identifiable {
        let id = UUID()
        let movie: String
        let rating: Int
        let comment: String
        let date: String
    }
    
    let reviews = [
        Review(movie: "Doctor Strange: MOM", rating: 5, comment: "Mind-blowing visuals! Benedict was amazing.", date: "Nov 20, 2025"),
        Review(movie: "The Batman", rating: 4, comment: "Dark and gritty. A bit long but worth it.", date: "Oct 15, 2025"),
        Review(movie: "Spider-Man: NWH", rating: 5, comment: "Best Spider-Man movie ever!", date: "Sep 05, 2025"),
        Review(movie: "Dune", rating: 4, comment: "Masterpiece of cinematography.", date: "Aug 22, 2025"),
        Review(movie: "Avatar: Way of Water", rating: 5, comment: "Beautiful underwater scenes.", date: "Jul 10, 2025")
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(reviews) { review in
                        HStack(alignment: .top) {
                            // Poster Placeholder Icon
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(LinearGradient(colors: [.appPurple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 60, height: 80)
                                Image(systemName: "film")
                                    .foregroundStyle(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(review.movie)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                
                                HStack(spacing: 2) {
                                    ForEach(0..<5, id: \.self) { i in
                                        Image(systemName: i < review.rating ? "star.fill" : "star")
                                            .font(.caption)
                                            .foregroundStyle(.yellow)
                                    }
                                    Text("• \(review.date)")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                        .padding(.leading, 5)
                                }
                                
                                Text(review.comment)
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.8))
                                    .lineLimit(2)
                                    .padding(.top, 2)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.backgroundColor2)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("My Reviews")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subviews เดิม (คงไว้ตามเดิม)

struct StatView: View {
    var value: String
    var title: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray.opacity(0.8))
        }
    }
}

struct GlassMenuRow: View {
    var icon: String
    var title: String
    var subTitle: String? = nil
    var isToggle: Bool = false
    
    @State private var toggleOn: Bool = true
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.backgroundColor2)
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundStyle(Color.appCyan)
                    .font(.system(size: 18))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundStyle(.white)
                    .font(.body)
                    .fontWeight(.medium)
                
                if let sub = subTitle {
                    Text(sub)
                        .foregroundStyle(.gray)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            if isToggle {
                Toggle("", isOn: $toggleOn)
                    .labelsHidden()
                    .tint(Color.appPink)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white.opacity(0.3))
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var username: String
    @Binding var bio: String
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Edit Profile")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.top, 20)
                
                VStack(alignment: .leading) {
                    Text("Username")
                        .foregroundStyle(.gray)
                        .font(.caption)
                    
                    TextField("Username", text: $username)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .foregroundStyle(.white)
                    
                    Text("Bio")
                        .foregroundStyle(.gray)
                        .font(.caption)
                        .padding(.top, 10)
                    
                    TextField("Bio", text: $bio)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .foregroundStyle(.white)
                }
                .padding()
                
                Button(action: { dismiss() }) {
                    Text("Save Changes")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appCyan)
                        .foregroundStyle(.white)
                        .cornerRadius(15)
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

struct PaymentMethodsView: View {
    @Binding var methods: [String]
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            
            VStack {
                List {
                    ForEach(methods, id: \.self) { method in
                        HStack {
                            Image(systemName: "creditcard.fill")
                                .foregroundStyle(Color.appPink)
                            Text(method)
                                .foregroundStyle(.white)
                            Spacer()
                            if method.contains("4242") {
                                Text("Default")
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.appCyan.opacity(0.2))
                                    .cornerRadius(5)
                                    .foregroundStyle(Color.appCyan)
                            }
                        }
                        .listRowBackground(Color.backgroundColor2)
                    }
                    .onDelete { indexSet in
                        methods.remove(atOffsets: indexSet)
                    }
                }
                .scrollContentBackground(.hidden)
                
                Button(action: {
                    withAnimation {
                        methods.append("**** **** **** \(Int.random(in: 1000...9999))")
                    }
                }) {
                    Label("Add New Card", systemImage: "plus")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.ultraThinMaterial)
                        .foregroundStyle(.white)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.appCyan, style: StrokeStyle(lineWidth: 1, dash: [5]))
                        )
                }
                .padding()
            }
        }
        .navigationTitle("Payment Methods")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MyTicketsView: View {
    @Environment(\.dismiss) var dismiss
    var ticketCount: Int
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.backgroundColor, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Text("My Tickets")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.gray)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(0..<ticketCount, id: \.self) { index in
                            HStack {
                                Image(systemName: "film.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.appPink)
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Doctor Strange: MOM")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text("Seat G\(index + 1) • Hall 4")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                    Text("November 25, 2025 | 18:00")
                                        .font(.caption)
                                        .foregroundStyle(Color.appCyan)
                                }
                                Spacer()
                                
                                Image(systemName: "qrcode")
                                    .font(.largeTitle)
                                    .foregroundStyle(.white)
                            }
                            .padding()
                            .background(
                                LinearGradient(colors: [.backgroundColor2, .appPurple.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
