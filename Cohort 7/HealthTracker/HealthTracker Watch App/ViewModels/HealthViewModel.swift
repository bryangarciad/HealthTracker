import Foundation
import Combine
import WatchKit

class HealthViewModel: ObservableObject {
    // MARK: - Published Variables
    @Published var todaysWater: Double = 0
    @Published var todaysCalories: Double = 0
    
    @Published var goals: UserGoals
    
    // MARK: - Computed Properties
    var caloriesProgress: Double {
        min(todaysCalories / UserGoals.defaultGoals.dailyCaloriesGoal, 1) // 0-1
    }
    
    var waterProgress: Double {
        min(todaysWater / UserGoals.defaultGoals.dailyWaterGoal, 1)
    }
    
    // MARK: - Services/Managers
    private let storageManager = StorageManager.shared
    
    init() {
        self.goals = storageManager.loadCurrentGoals()
        refreshDailyTotals()
    }
    
    func updateGoals(calories: Double, water: Double) {
        goals = UserGoals(
            dailyCaloriesGoal: calories, dailyWaterGoal: water
        )
        storageManager.saveNewGoals(goals)
        WKInterfaceDevice.current().play(.success)
    }
    
    func refreshDailyTotals() {
        todaysCalories = storageManager.getTodayTotal(for: .calories)
        todaysWater = storageManager.getTodayTotal(for: .water)
    }
    
    func addCalories(_ amount: Double) {
        let entry = DiaryEntry(
            type: .calories,
            value: amount
        )
        storageManager.addEntry(entry)
    }
    
    func addWater(_ amount: Double) {
        let entry = DiaryEntry(
            type: .water,
            value: amount
        )
        storageManager.addEntry(entry)
    }
}
