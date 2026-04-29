import SwiftUI
import Combine
import Foundation

@MainActor
class HealtTrackerViewModel: ObservableObject {
    @Published var goals: UserGoals
    @Published var todaysCalories: Double = 0
    @Published var todaysWater: Double = 0

    
    var caloriesProgress: Double {
        min(todaysCalories / goals.dailyCaloriesGoal, 1.0)
    }
    
    var waterProgress: Double {
        min(todaysWater / goals.dailyWaterGoal, 1.0)
    }
    
    // MARK: - View Model For Storage Manager
    private let storageManager = StorageManager.shared
    
    init() {
        self.goals = StorageManager.shared.loadGoals()
        refreshTodaysData()
    }
    
    func updateGoals(calories: Double, water: Double) {
        goals = UserGoals(dailyCaloriesGoal: calories, dailyWaterGoal: water)
        storageManager.saveGoals(goals)
    }
    
    func addCalories(_ amount: Double) {
        let entry = DiaryEntry(type: .calories, value: amount)
        storageManager.addEntry(entry)
        
        todaysCalories += amount
    }
    
    func addWater(_ amount: Double) {
        let entry = DiaryEntry(type: .water, value: amount)
        storageManager.addEntry(entry)
        
        todaysWater += amount
    }
    
    func refreshTodaysData() {
        todaysCalories = storageManager.getTodaysTotal(for: .calories)
        todaysWater = storageManager.getTodaysTotal(for: .water)
    }
    
}
