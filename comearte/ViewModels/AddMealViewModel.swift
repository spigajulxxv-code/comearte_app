import Foundation
import UIKit

/// Handles creating and editing meals.
final class AddMealViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var quantity: String = "1"
    @Published var category: String = ""
    @Published var calories: String = "0"
    @Published var protein: String = "0"
    @Published var carbs: String = "0"
    @Published var fat: String = "0"
    @Published var selectedImage: UIImage?

    private let mealService = MealService()
    private let imageStorage = ImageStorage.self

    func save(userId: Int64) async {
        do {
            var photoPath: String?
            if let selectedImage {
                photoPath = try imageStorage.save(image: selectedImage, name: UUID().uuidString + ".jpg")
            }
            let meal = Meal(
                id: nil,
                userId: userId,
                name: name,
                quantity: Double(quantity) ?? 1,
                category: category,
                calories: Double(calories) ?? 0,
                protein: Double(protein) ?? 0,
                carbs: Double(carbs) ?? 0,
                fat: Double(fat) ?? 0,
                photoPath: photoPath,
                date: Date()
            )
            try await mealService.addMeal(meal)
        } catch {
            print("Save meal failed: \(error)")
        }
    }
}
