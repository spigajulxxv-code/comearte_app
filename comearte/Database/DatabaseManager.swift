import Foundation
import GRDB

/// Handles database initialization, migrations, and provides helper CRUD operations.
final class DatabaseManager {
    static let shared = DatabaseManager()
    private let databaseFileName = "comearte.sqlite"
    private var dbQueue: DatabaseQueue?

    private init() {}

    /// Sets up the database by creating the file (if needed) and running migrations.
    func setupDatabase() {
        do {
            let fileManager = FileManager.default
            let folderURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dbURL = folderURL.appendingPathComponent(databaseFileName)
            dbQueue = try DatabaseQueue(path: dbURL.path)
            try DatabaseMigrations.migrate(dbQueue: dbQueue!)
        } catch {
            print("Database setup failed: \(error)")
        }
    }

    // MARK: - Accessor
    func read<T>(_ block: (Database) throws -> T) rethrows -> T {
        guard let dbQueue else { fatalError("Database not initialized") }
        return try dbQueue.read(block)
    }

    func write<T>(_ block: (inout Database) throws -> T) rethrows -> T {
        guard let dbQueue else { fatalError("Database not initialized") }
        return try dbQueue.write(block)
    }

    // MARK: - Generic CRUD helpers
    func insertRecord<T: PersistableRecord>(_ record: T) async throws {
        try await write { db in
            try record.insert(db)
        }
    }

    func updateRecord<T: MutablePersistableRecord>(_ record: inout T) async throws {
        try await write { db in
            try record.update(db)
        }
    }

    func deleteRecord<T: PersistableRecord & FetchableRecord>(_ record: T) async throws where T.RowDecoder == T {
        try await write { db in
            try record.delete(db)
        }
    }
}
