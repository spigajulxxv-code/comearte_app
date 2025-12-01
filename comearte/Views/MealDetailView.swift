import SwiftUI

/// Detail screen for a single meal with edit/delete actions.
struct MealDetailView: View {
    @State var meal: Meal
    @State private var showingEdit = false
    private let mealService = MealService()

    var body: some View {
        Form {
            Section(header: Text("Info")) {
                Text(meal.name)
                Text("Category: \(meal.category)")
                Text("Quantity: \(meal.quantity)")
                Text("Date: \(DateUtils.formatted(meal.date))")
            }
            Section(header: Text("Nutrition")) {
                Text("Calories: \(meal.calories, specifier: "%.0f")")
                Text("Protein: \(meal.protein, specifier: "%.0f") g")
                Text("Carbs: \(meal.carbs, specifier: "%.0f") g")
                Text("Fat: \(meal.fat, specifier: "%.0f") g")
            }
            if let path = meal.photoPath, let image = ImageStorage.loadImage(named: path) {
                Section(header: Text("Photo")) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
            }
            Button(role: .destructive) { Task { await deleteMeal() } } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .navigationTitle(meal.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { Button("Edit") { showingEdit = true } }
        }
        .sheet(isPresented: $showingEdit) {
            AddMealView(user: User(id: meal.userId, email: "", passwordHash: "", createdAt: Date()))
        }
    }

    private func deleteMeal() async {
        do {
            try await mealService.deleteMeal(meal)
        } catch {
            print("Delete meal error: \(error)")
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { MealDetailView(meal: Meal(id: 1, userId: 1, name: "Salad", quantity: 1, category: "Lunch", calories: 350, protein: 20, carbs: 30, fat: 10, photoPath: nil, date: Date())) }
    }
}
