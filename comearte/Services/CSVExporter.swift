import Foundation

/// Exports meal data to a CSV string.
final class CSVExporter {
    func export(meals: [Meal]) -> String {
        var csv = "Name,Quantity,Category,Calories,Protein,Carbs,Fat,Date\n"
        let formatter = ISO8601DateFormatter()
        meals.forEach { meal in
            let row = "\(meal.name),\(meal.quantity),\(meal.category),\(meal.calories),\(meal.protein),\(meal.carbs),\(meal.fat),\(formatter.string(from: meal.date))\n"
            csv.append(row)
        }
        return csv
    }
}
