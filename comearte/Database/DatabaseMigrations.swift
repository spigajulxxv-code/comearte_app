import Foundation
import GRDB

/// Manages all database migrations for the application.
enum DatabaseMigrations {
    static func migrate(dbQueue: DatabaseQueue) throws {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("createUsers") { db in
            try db.create(table: "users") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("email", .text).unique().notNull()
                t.column("password_hash", .text).notNull()
                t.column("created_at", .datetime).notNull()
            }
        }

        migrator.registerMigration("createMeals") { db in
            try db.create(table: "meals") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("user_id", .integer).notNull().references("users", onDelete: .cascade)
                t.column("name", .text).notNull()
                t.column("quantity", .double).notNull()
                t.column("category", .text).notNull()
                t.column("calories", .double).notNull()
                t.column("protein", .double).notNull()
                t.column("carbs", .double).notNull()
                t.column("fat", .double).notNull()
                t.column("photo_path", .text)
                t.column("date", .datetime).notNull()
            }
        }

        migrator.registerMigration("createFoods") { db in
            try db.create(table: "foods") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
                t.column("calories", .double).notNull()
                t.column("protein", .double).notNull()
                t.column("carbs", .double).notNull()
                t.column("fat", .double).notNull()
            }
        }

        migrator.registerMigration("createGoals") { db in
            try db.create(table: "goals") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("user_id", .integer).notNull().references("users", onDelete: .cascade)
                t.column("daily_calories", .double).notNull()
                t.column("daily_protein", .double).notNull()
                t.column("daily_carbs", .double).notNull()
                t.column("daily_fat", .double).notNull()
            }
        }

        migrator.registerMigration("createFavorites") { db in
            try db.create(table: "favorites") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("user_id", .integer).notNull().references("users", onDelete: .cascade)
                t.column("meal_name", .text).notNull()
                t.column("calories", .double).notNull()
                t.column("protein", .double).notNull()
                t.column("carbs", .double).notNull()
                t.column("fat", .double).notNull()
            }
        }

        try migrator.migrate(dbQueue)
    }
}
