import Foundation

/// Handles CRUD operations for favorite meals.
final class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Favorite] = []
    private let database = DatabaseManager.shared
    private let mealService = MealService()

    func loadFavorites(userId: Int64) {
        do {
            favorites = try database.read { db in
                try Favorite.filter(Favorite.Columns.userId == userId).fetchAll(db)
            }
        } catch {
            print("Load favorites error: \(error)")
        }
    }

    func addFavorite(from meal: Meal) async {
        guard let userId = meal.userId as Int64? else { return }
        let favorite = Favorite(
            id: nil,
            userId: userId,
            mealName: meal.name,
            calories: meal.calories,
            protein: meal.protein,
            carbs: meal.carbs,
            fat: meal.fat
        )
        do {
            try await database.insertRecord(favorite)
            loadFavorites(userId: userId)
        } catch {
            print("Add favorite error: \(error)")
        }
    }

    func addFavoriteToToday(_ favorite: Favorite) async {
        let meal = Meal(
            id: nil,
            userId: favorite.userId,
            name: favorite.mealName,
            quantity: 1,
            category: "Favorite",
            calories: favorite.calories,
            protein: favorite.protein,
            carbs: favorite.carbs,
            fat: favorite.fat,
            photoPath: nil,
            date: Date()
        )
        do {
            try await mealService.addMeal(meal)
        } catch {
            print("Add favorite meal error: \(error)")
        }
    }
}
