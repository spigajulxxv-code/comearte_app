import SwiftUI

/// Login screen allowing existing users to sign in.
struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingRegister = false

    var body: some View {
        VStack(spacing: 24) {
            Text("comearte")
                .font(.largeTitle.bold())
            VStack(alignment: .leading, spacing: 12) {
                TextField("Email", text: $authViewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $authViewModel.password)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))

            if let error = authViewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }

            Button(action: { Task { await authViewModel.login() } }) {
                Label("Login", systemImage: "arrow.right.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button("Create account") { showingRegister = true }
                .sheet(isPresented: $showingRegister) { RegisterView() }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthViewModel())
    }
}
