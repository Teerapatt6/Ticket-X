import SwiftUI

struct ContentView: View {
    
    @State var currentTab: Tab = .home
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TabView(selection: $currentTab) {
                    
                    HomeView()
                        .tag(Tab.home)
                        .toolbar(.hidden, for: .tabBar)
                    
                    LocationView()
                        .tag(Tab.location)
                        .toolbar(.hidden, for: .tabBar)
                    
                    TicketView()
                        .tag(Tab.ticket)
                        .toolbar(.hidden, for: .tabBar)
                    
                    CategoryView()
                        .tag(Tab.category)
                        .toolbar(.hidden, for: .tabBar)
                    
                    ProfileView()
                        .tag(Tab.profile)
                        .toolbar(.hidden, for: .tabBar)
                }
                
                CustomTabBar(currentTab: $currentTab)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    ContentView()
}
