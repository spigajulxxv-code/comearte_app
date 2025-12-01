import Foundation
import GRDB

/// Represents a saved favorite meal template for quick logging.
struct Favorite: Codable, FetchableRecord, PersistableRecord, TableRecord, Identifiable {
    var id: Int64?
    var userId: Int64
    var mealName: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double

    static var databaseTableName: String { "favorites" }

    enum Columns {
        static let id = Column("id")
        static let userId = Column("user_id")
        static let mealName = Column("meal_name")
        static let calories = Column("calories")
        static let protein = Column("protein")
        static let carbs = Column("carbs")
        static let fat = Column("fat")
    }
}
