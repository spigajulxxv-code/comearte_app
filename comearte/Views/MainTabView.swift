import SwiftUI

/// Main navigation tabs once authenticated.
struct MainTabView: View {
    let user: User

    var body: some View {
        TabView {
            DashboardView(user: user)
                .tabItem { Label("Dashboard", systemImage: "chart.pie.fill") }
            HistoryView(user: user)
                .tabItem { Label("History", systemImage: "clock.fill") }
            GoalsView(user: user)
                .tabItem { Label("Goals", systemImage: "target") }
            FavoritesView(user: user)
                .tabItem { Label("Favorites", systemImage: "heart.fill") }
            SettingsView(user: user)
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(user: User(id: 1, email: "demo@example.com", passwordHash: "", createdAt: Date()))
    }
}
