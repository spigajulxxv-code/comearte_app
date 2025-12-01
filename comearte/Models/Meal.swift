import Foundation
import GRDB

/// Represents a logged meal entry with nutritional information.
struct Meal: Codable, FetchableRecord, PersistableRecord, TableRecord, Identifiable {
    var id: Int64?
    var userId: Int64
    var name: String
    var quantity: Double
    var category: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
    var photoPath: String?
    var date: Date

    static var databaseTableName: String { "meals" }

    enum Columns {
        static let id = Column("id")
        static let userId = Column("user_id")
        static let name = Column("name")
        static let quantity = Column("quantity")
        static let category = Column("category")
        static let calories = Column("calories")
        static let protein = Column("protein")
        static let carbs = Column("carbs")
        static let fat = Column("fat")
        static let photoPath = Column("photo_path")
        static let date = Column("date")
    }
}
