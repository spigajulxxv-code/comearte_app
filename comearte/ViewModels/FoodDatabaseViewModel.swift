import Foundation

/// View model for browsing and searching the food database.
final class FoodDatabaseViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var searchText: String = "" {
        didSet { search() }
    }

    private let foodService = FoodService()

    func loadFoods() {
        do {
            foods = try foodService.foods()
        } catch {
            print("Load foods error: \(error)")
        }
    }

    func addFood(name: String, calories: Double, protein: Double, carbs: Double, fat: Double) async {
        do {
            let food = Food(id: nil, name: name, calories: calories, protein: protein, carbs: carbs, fat: fat)
            try await foodService.addFood(food)
            loadFoods()
        } catch {
            print("Add food error: \(error)")
        }
    }

    func search() {
        guard !searchText.isEmpty else { return loadFoods() }
        do {
            foods = try foodService.searchFoods(query: searchText)
        } catch {
            print("Search foods error: \(error)")
        }
    }
}
