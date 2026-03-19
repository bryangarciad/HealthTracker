import SwiftUI
import Combine

@MainActor
class HealthViewModel: ObservableObject {
    
    @Published var goals: UserGoals
    @Published var todaysCalories: Double = 0
    @Published var todaysWater: Double = 0
    
    var caloriesProgress: Double {
        min(todaysCalories / goals.dailyCaloriesGoal, 1.0)
    }
    
    var waterProgress: Double {
        min(todaysWater / goals.dailyWaterGoal, 1.0)
    }
    
    
    init() {
        self.goals = StorageManager.shared.loadGoals()
        self.todaysCalories = StorageManager.shared.getTodaysTotal(for: .calories)
        self.todaysWater = StorageManager.shared.getTodaysTotal(for: .water)
    }
}
