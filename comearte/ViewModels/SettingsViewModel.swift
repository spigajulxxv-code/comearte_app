import Foundation
import SwiftUI

/// Handles app-wide settings such as theme and exports.
final class SettingsViewModel: ObservableObject {
    @AppStorage("colorScheme") var colorScheme: String = "system"
    private let exporter = CSVExporter()
    private let mealService = MealService()

    func exportCSV(for user: User) -> String {
        do {
            let meals = try mealService.meals(for: user.id ?? 0)
            return exporter.export(meals: meals)
        } catch {
            return ""
        }
    }

    func currentColorScheme() -> ColorScheme? {
        switch colorScheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}
