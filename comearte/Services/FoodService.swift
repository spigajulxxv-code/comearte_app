import Foundation
import GRDB

/// CRUD service for saved foods library.
final class FoodService {
    private let database = DatabaseManager.shared

    func addFood(_ food: Food) async throws {
        try await database.insertRecord(food)
    }

    func foods() throws -> [Food] {
        try database.read { db in
            try Food.order(Food.Columns.name.asc).fetchAll(db)
        }
    }

    func searchFoods(query: String) throws -> [Food] {
        try database.read { db in
            try Food.filter(Food.Columns.name.like("%\(query)%")).fetchAll(db)
        }
    }
}
