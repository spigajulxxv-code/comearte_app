import SwiftUI

/// Screen to set calorie and macro goals.
struct GoalsView: View {
    let user: User
    @StateObject private var viewModel = GoalsViewModel()

    var body: some View {
        Form {
            Section(header: Text("Daily Goals")) {
                TextField("Calories", text: $viewModel.dailyCalories).keyboardType(.decimalPad)
                TextField("Protein", text: $viewModel.dailyProtein).keyboardType(.decimalPad)
                TextField("Carbs", text: $viewModel.dailyCarbs).keyboardType(.decimalPad)
                TextField("Fat", text: $viewModel.dailyFat).keyboardType(.decimalPad)
            }
            Button("Save") {
                Task { await viewModel.save(userId: user.id ?? 0) }
            }
        }
        .navigationTitle("Goals")
        .onAppear { viewModel.load(userId: user.id ?? 0) }
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { GoalsView(user: User(id: 1, email: "demo", passwordHash: "", createdAt: Date())) }
    }
}
