import Foundation

/// Handles saving and loading daily macro goals.
final class GoalsViewModel: ObservableObject {
    @Published var dailyCalories: String = ""
    @Published var dailyProtein: String = ""
    @Published var dailyCarbs: String = ""
    @Published var dailyFat: String = ""

    private let goalService = GoalService()

    func load(userId: Int64) {
        do {
            if let goal = try goalService.loadGoal(for: userId) {
                dailyCalories = String(goal.dailyCalories)
                dailyProtein = String(goal.dailyProtein)
                dailyCarbs = String(goal.dailyCarbs)
                dailyFat = String(goal.dailyFat)
            }
        } catch {
            print("Load goal error: \(error)")
        }
    }

    func save(userId: Int64) async {
        let goal = Goal(
            id: nil,
            userId: userId,
            dailyCalories: Double(dailyCalories) ?? 0,
            dailyProtein: Double(dailyProtein) ?? 0,
            dailyCarbs: Double(dailyCarbs) ?? 0,
            dailyFat: Double(dailyFat) ?? 0
        )
        do {
            try await goalService.saveGoal(goal)
        } catch {
            print("Save goal error: \(error)")
        }
    }
}
