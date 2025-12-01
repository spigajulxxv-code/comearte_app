import XCTest
import GRDB
@testable import comearte

final class DatabaseManagerTests: XCTestCase {
    func testMigrationsCreateTables() throws {
        let dbQueue = DatabaseQueue()
        try DatabaseMigrations.migrate(dbQueue: dbQueue)

        try dbQueue.read { db in
            XCTAssertTrue(try db.tableExists("users"))
            XCTAssertTrue(try db.tableExists("meals"))
            XCTAssertTrue(try db.tableExists("foods"))
            XCTAssertTrue(try db.tableExists("goals"))
            XCTAssertTrue(try db.tableExists("favorites"))
        }
    }

    func testInsertUser() async throws {
        let manager = DatabaseManager.shared
        manager.setupDatabase()
        let authService = AuthService()
        let user = try await authService.register(email: "unit@test.com", password: "password123")
        XCTAssertNotNil(user.id)
    }
}
