import Foundation

/// Provides aggregated data for history charts.
final class HistoryViewModel: ObservableObject {
    struct ChartPoint: Identifiable {
        let id = UUID()
        let date: Date
        let calories: Double
        let protein: Double
        let carbs: Double
        let fat: Double
    }

    @Published var range: RangeType = .day
    @Published var points: [ChartPoint] = []

    enum RangeType: String, CaseIterable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
    }

    private let mealService = MealService()

    func load(userId: Int64) {
        do {
            let meals = try mealService.meals(for: userId)
            points = aggregate(meals: meals)
        } catch {
            print("History load error: \(error)")
        }
    }

    private func aggregate(meals: [Meal]) -> [ChartPoint] {
        let grouped: [Date: [Meal]]
        switch range {
        case .day:
            grouped = Dictionary(grouping: meals, by: { DateUtils.startOfDay(for: $0.date) })
        case .week:
            grouped = Dictionary(grouping: meals, by: { DateUtils.startOfWeek(for: $0.date) })
        case .month:
            grouped = Dictionary(grouping: meals, by: { DateUtils.startOfMonth(for: $0.date) })
        }

        return grouped.map { key, value in
            let calories = value.reduce(0) { $0 + $1.calories }
            let protein = value.reduce(0) { $0 + $1.protein }
            let carbs = value.reduce(0) { $0 + $1.carbs }
            let fat = value.reduce(0) { $0 + $1.fat }
            return ChartPoint(date: key, calories: calories, protein: protein, carbs: carbs, fat: fat)
        }.sorted { $0.date < $1.date }
    }
}
