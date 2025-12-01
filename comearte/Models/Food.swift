import Foundation
import GRDB

/// Represents a reusable food template used when creating meals.
struct Food: Codable, FetchableRecord, PersistableRecord, TableRecord, Identifiable {
    var id: Int64?
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double

    static var databaseTableName: String { "foods" }

    enum Columns {
        static let id = Column("id")
        static let name = Column("name")
        static let calories = Column("calories")
        static let protein = Column("protein")
        static let carbs = Column("carbs")
        static let fat = Column("fat")
    }
}
