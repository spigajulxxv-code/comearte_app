import Foundation
import GRDB

/// Manages persistence for calorie and macro goals.
final class GoalService {
    private let database = DatabaseManager.shared

    func saveGoal(_ goal: Goal) async throws {
        try await database.insertRecord(goal)
    }

    func loadGoal(for userId: Int64) throws -> Goal? {
        try database.read { db in
            try Goal.filter(Goal.Columns.userId == userId).fetchOne(db)
        }
    }
}
