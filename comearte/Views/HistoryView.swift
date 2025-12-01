import SwiftUI
import Charts

/// Shows historical calorie and macro trends with charts.
struct HistoryView: View {
    let user: User
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Picker("Range", selection: $viewModel.range) {
                    ForEach(HistoryViewModel.RangeType.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Chart(viewModel.points) { point in
                    BarMark(x: .value("Date", point.date), y: .value("Calories", point.calories))
                        .foregroundStyle(.orange)
                }
                .frame(height: 200)
                .padding()

                Chart(viewModel.points) { point in
                    LineMark(x: .value("Date", point.date), y: .value("Protein", point.protein))
                        .foregroundStyle(.green)
                    LineMark(x: .value("Date", point.date), y: .value("Carbs", point.carbs))
                        .foregroundStyle(.blue)
                    LineMark(x: .value("Date", point.date), y: .value("Fat", point.fat))
                        .foregroundStyle(.purple)
                }
                .frame(height: 200)
                .padding()
            }
        }
        .navigationTitle("History")
        .onAppear { viewModel.load(userId: user.id ?? 0) }
        .onChange(of: viewModel.range) { _ in viewModel.load(userId: user.id ?? 0) }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { HistoryView(user: User(id: 1, email: "demo", passwordHash: "", createdAt: Date())) }
    }
}
