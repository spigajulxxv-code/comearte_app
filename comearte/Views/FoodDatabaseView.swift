import SwiftUI

/// Lists saved foods with search and quick add.
struct FoodDatabaseView: View {
    @StateObject private var viewModel = FoodDatabaseViewModel()
    var onSelect: ((Food) -> Void)?

    @State private var showingAdd = false
    @State private var newFood = Food(id: nil, name: "", calories: 0, protein: 0, carbs: 0, fat: 0)

    var body: some View {
        List {
            ForEach(viewModel.foods) { food in
                Button {
                    onSelect?(food)
                } label: {
                    VStack(alignment: .leading) {
                        Text(food.name)
                        Text("\(food.calories, specifier: "%.0f") kcal • P \(food.protein, specifier: "%.0f") C \(food.carbs, specifier: "%.0f") F \(food.fat, specifier: "%.0f")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .navigationTitle("Foods")
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button(action: { showingAdd = true }) { Image(systemName: "plus") } } }
        .onAppear { viewModel.loadFoods() }
        .sheet(isPresented: $showingAdd) { addSheet }
    }

    private var addSheet: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $newFood.name)
                TextField("Calories", value: $newFood.calories, format: .number).keyboardType(.decimalPad)
                TextField("Protein", value: $newFood.protein, format: .number).keyboardType(.decimalPad)
                TextField("Carbs", value: $newFood.carbs, format: .number).keyboardType(.decimalPad)
                TextField("Fat", value: $newFood.fat, format: .number).keyboardType(.decimalPad)
            }
            .navigationTitle("Add Food")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Close", action: { showingAdd = false }) }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await viewModel.addFood(name: newFood.name, calories: newFood.calories, protein: newFood.protein, carbs: newFood.carbs, fat: newFood.fat)
                            showingAdd = false
                        }
                    }
                }
            }
        }
    }
}

struct FoodDatabaseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { FoodDatabaseView() }
    }
}
