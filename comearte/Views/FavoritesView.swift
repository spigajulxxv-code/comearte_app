import SwiftUI

/// Lists favorite meals and allows quick logging.
struct FavoritesView: View {
    let user: User
    @StateObject private var viewModel = FavoritesViewModel()

    var body: some View {
        List {
            ForEach(viewModel.favorites) { favorite in
                HStack {
                    VStack(alignment: .leading) {
                        Text(favorite.mealName)
                        Text("\(favorite.calories, specifier: "%.0f") kcal")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(action: { Task { await viewModel.addFavoriteToToday(favorite) } }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .onAppear { viewModel.loadFavorites(userId: user.id ?? 0) }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { FavoritesView(user: User(id: 1, email: "demo", passwordHash: "", createdAt: Date())) }
    }
}
