import Foundation
import GRDB

/// Represents an application user stored in SQLite.
struct User: Codable, FetchableRecord, PersistableRecord, TableRecord {
    var id: Int64?
    var email: String
    var passwordHash: String
    var createdAt: Date

    static var databaseTableName: String { "users" }

    enum Columns {
        static let id = Column("id")
        static let email = Column("email")
        static let passwordHash = Column("password_hash")
        static let createdAt = Column("created_at")
    }

    init(id: Int64? = nil, email: String, passwordHash: String, createdAt: Date = Date()) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
        self.createdAt = createdAt
    }
}
