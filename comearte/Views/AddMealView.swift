import SwiftUI
import PhotosUI

/// Form for adding a new meal.
struct AddMealView: View {
    let user: User
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddMealViewModel()
    @State private var photoItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Meal")) {
                    TextField("Name", text: $viewModel.name)
                    TextField("Category", text: $viewModel.category)
                    TextField("Quantity", text: $viewModel.quantity)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Nutrition")) {
                    TextField("Calories", text: $viewModel.calories).keyboardType(.decimalPad)
                    TextField("Protein", text: $viewModel.protein).keyboardType(.decimalPad)
                    TextField("Carbs", text: $viewModel.carbs).keyboardType(.decimalPad)
                    TextField("Fat", text: $viewModel.fat).keyboardType(.decimalPad)
                }

                Section(header: Text("Photo")) {
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        Label("Choose Photo", systemImage: "photo")
                    }
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 160)
                    }
                }
            }
            .navigationTitle("Add Meal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Close", action: { dismiss() }) }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await viewModel.save(userId: user.id ?? 0)
                            dismiss()
                        }
                    }
                }
            }
            .onChange(of: photoItem) { item in
                Task {
                    if let data = try? await item?.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                        viewModel.selectedImage = image
                    }
                }
            }
        }
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(user: User(id: 1, email: "demo", passwordHash: "", createdAt: Date()))
    }
}
