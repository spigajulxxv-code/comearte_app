import Foundation
import Combine

/// Manages user authentication state and input validation.
final class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = UserDefaults.standard.bool(forKey: "isAuthenticated")
    @Published var currentUser: User?

    private let authService = AuthService()

    func validateCredentials() -> Bool {
        guard email.contains("@"), email.contains("."), password.count >= 6 else {
            errorMessage = "Please enter a valid email and password (6+ characters)."
            return false
        }
        if !confirmPassword.isEmpty && password != confirmPassword {
            errorMessage = "Passwords do not match."
            return false
        }
        errorMessage = nil
        return true
    }

    func register() async {
        guard validateCredentials() else { return }
        do {
            currentUser = try await authService.register(email: email.lowercased(), password: password)
            markAuthenticated()
        } catch {
            errorMessage = "Registration failed: \(error.localizedDescription)"
        }
    }

    func login() async {
        guard validateCredentials() else { return }
        do {
            if let user = try await authService.login(email: email.lowercased(), password: password) {
                currentUser = user
                markAuthenticated()
            } else {
                errorMessage = "Invalid credentials"
            }
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
        }
    }

    func logout() {
        currentUser = nil
        isAuthenticated = false
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
    }

    private func markAuthenticated() {
        isAuthenticated = true
        UserDefaults.standard.set(true, forKey: "isAuthenticated")
    }
}
