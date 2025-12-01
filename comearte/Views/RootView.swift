import SwiftUI

/// Root entry point view deciding between auth and main content.
struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            if authViewModel.isAuthenticated, let user = authViewModel.currentUser {
                MainTabView(user: user)
            } else {
                LoginView()
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(AuthViewModel())
    }
}
