import Foundation
import GRDB

/// Handles user authentication and registration workflows.
final class AuthService {
    private let database = DatabaseManager.shared

    func register(email: String, password: String) async throws -> User {
        let hashed = PasswordHasher.hash(password)
        let user = User(email: email, passwordHash: hashed, createdAt: Date())
        try await database.insertRecord(user)
        return user
    }

    func login(email: String, password: String) async throws -> User? {
        let hashed = PasswordHasher.hash(password)
        return try database.read { db in
            try User
                .filter(User.Columns.email == email && User.Columns.passwordHash == hashed)
                .fetchOne(db)
        }
    }

    func userExists(email: String) throws -> Bool {
        try database.read { db in
            try User.filter(User.Columns.email == email).fetchCount(db) > 0
        }
    }
}
