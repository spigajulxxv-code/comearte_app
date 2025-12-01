import Foundation

/// View model for the dashboard summary.
final class DashboardViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var totals: (calories: Double, protein: Double, carbs: Double, fat: Double) = (0, 0, 0, 0)

    private let mealService = MealService()

    func load(for user: User) {
        do {
            meals = try mealService.meals(for: user.id ?? 0, date: Date())
            totals = try mealService.totals(for: user.id ?? 0, date: Date())
        } catch {
            print("Dashboard load error: \(error)")
        }
    }
}
