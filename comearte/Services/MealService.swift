import Foundation
import GRDB

/// Provides CRUD operations for meals and helpers for calculating totals.
final class MealService {
    private let database = DatabaseManager.shared

    func addMeal(_ meal: Meal) async throws {
        try await database.insertRecord(meal)
    }

    func updateMeal(_ meal: inout Meal) async throws {
        try await database.updateRecord(&meal)
    }

    func deleteMeal(_ meal: Meal) async throws {
        try await database.deleteRecord(meal)
    }

    func meals(for userId: Int64, date: Date? = nil) throws -> [Meal] {
        try database.read { db in
            var request = Meal.filter(Meal.Columns.userId == userId).order(Meal.Columns.date.desc)
            if let date {
                let start = DateUtils.startOfDay(for: date)
                let end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? start
                request = request.filter(Meal.Columns.date >= start && Meal.Columns.date < end)
            }
            return try request.fetchAll(db)
        }
    }

    func totals(for userId: Int64, date: Date = Date()) throws -> (calories: Double, protein: Double, carbs: Double, fat: Double) {
        let meals = try meals(for: userId, date: date)
        let calories = meals.reduce(0) { $0 + $1.calories }
        let protein = meals.reduce(0) { $0 + $1.protein }
        let carbs = meals.reduce(0) { $0 + $1.carbs }
        let fat = meals.reduce(0) { $0 + $1.fat }
        return (calories, protein, carbs, fat)
    }

    func autocomplete(query: String) throws -> [Meal] {
        try database.read { db in
            try Meal.filter(Meal.Columns.name.like("%\(query)%")).fetchAll(db)
        }
    }
}
