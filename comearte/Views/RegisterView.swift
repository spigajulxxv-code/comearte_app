import SwiftUI

/// Registration screen for new users.
struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account")) {
                    TextField("Email", text: $authViewModel.email)
                    SecureField("Password", text: $authViewModel.password)
                    SecureField("Confirm Password", text: $authViewModel.confirmPassword)
                }
                if let error = authViewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                }
                Button("Create Account") {
                    Task {
                        await authViewModel.register()
                        if authViewModel.isAuthenticated { dismiss() }
                    }
                }
            }
            .navigationTitle("Register")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Close", action: { dismiss() }) }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView().environmentObject(AuthViewModel())
    }
}
