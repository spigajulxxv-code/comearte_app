import SwiftUI

/// App settings including theme, CSV export, and logout.
struct SettingsView: View {
    let user: User
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Picker("Theme", selection: $viewModel.colorScheme) {
                    Text("System").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
            }
            Section(header: Text("Data")) {
                Button("Export Meals to CSV") {
                    let csv = viewModel.exportCSV(for: user)
                    print(csv)
                }
            }
            Section(header: Text("Account")) {
                Button(role: .destructive) {
                    authViewModel.logout()
                } label: {
                    Text("Logout")
                }
            }
        }
        .navigationTitle("Settings")
        .preferredColorScheme(viewModel.currentColorScheme())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { SettingsView(user: User(id: 1, email: "demo", passwordHash: "", createdAt: Date())) }.environmentObject(AuthViewModel())
    }
}
