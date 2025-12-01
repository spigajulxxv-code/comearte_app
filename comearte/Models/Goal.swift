import Foundation
import GRDB

/// Represents daily macro and calorie goals for a user.
struct Goal: Codable, FetchableRecord, PersistableRecord, TableRecord, Identifiable {
    var id: Int64?
    var userId: Int64
    var dailyCalories: Double
    var dailyProtein: Double
    var dailyCarbs: Double
    var dailyFat: Double

    static var databaseTableName: String { "goals" }

    enum Columns {
        static let id = Column("id")
        static let userId = Column("user_id")
        static let dailyCalories = Column("daily_calories")
        static let dailyProtein = Column("daily_protein")
        static let dailyCarbs = Column("daily_carbs")
        static let dailyFat = Column("daily_fat")
    }
}
