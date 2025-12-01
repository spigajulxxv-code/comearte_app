import SwiftUI

@main
struct ComearteApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        DatabaseManager.shared.setupDatabase()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
        }
    }
}
