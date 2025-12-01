import SwiftUI

/// Displays today's summary and list of meals.
struct DashboardView: View {
    let user: User
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showingAddMeal = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                macros
                mealList
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddMeal = true }) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .onAppear { viewModel.load(for: user) }
        .sheet(isPresented: $showingAddMeal, onDismiss: { viewModel.load(for: user) }) {
            AddMealView(user: user)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Calories")
                .font(.headline)
            ProgressView(value: viewModel.totals.calories, total: 2000)
                .tint(.orange)
            Text("\(Int(viewModel.totals.calories)) kcal")
                .font(.title.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
    }

    private var macros: some View {
        HStack(spacing: 16) {
            macroCard(title: "Protein", value: viewModel.totals.protein, color: .green)
            macroCard(title: "Carbs", value: viewModel.totals.carbs, color: .blue)
            macroCard(title: "Fat", value: viewModel.totals.fat, color: .purple)
        }
    }

    private func macroCard(title: String, value: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.caption)
            Text("\(Int(value)) g").font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.1)))
    }

    private var mealList: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack { Text("Meals").font(.headline); Spacer() }
            ForEach(viewModel.meals) { meal in
                NavigationLink(destination: MealDetailView(meal: meal)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(meal.name).font(.headline)
                            Text("\(meal.calories, specifier: "%.0f") kcal")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DashboardView(user: User(id: 1, email: "demo", passwordHash: "", createdAt: Date()))
        }
    }
}
