import SwiftUI
import Combine
import WatchKit

@MainActor
class HealthViewModel: ObservableObject {
    
    @Published var goals: UserGoals
    @Published var todaysCalories: Double = 0
    @Published var todaysWater: Double = 0
    
    // MARK: - Computed Properties
    var caloriesProgress: Double {
        min(todaysCalories / goals.dailyCaloriesGoal, 1.0)
    }
    
    var waterProgress: Double {
        min(todaysWater / goals.dailyWaterGoal, 1.0)
    }
    
    var caloriesGoalMet: Bool {
        todaysCalories >= goals.dailyCaloriesGoal
    }
    
    var waterGoalMet: Bool {
        todaysWater >= goals.dailyWaterGoal
    }
    
    // MARK: - Initialization
    init() {
        self.goals = StorageManager.shared.loadGoals()
        refreshTodaysData()
    }
    
    // MARK: - Public Methods
    
    func refreshTodaysData() {
        self.todaysCalories = StorageManager.shared.getTodaysTotal(for: .calories)
        self.todaysWater = StorageManager.shared.getTodaysTotal(for: .water)
    }
    
    func addCalories(_ amount: Double) {
        let caloriesEntry = DiaryEntry(
            type: .calories,
            value: amount
        )
        
        StorageManager.shared.addEntry(caloriesEntry)
        
        todaysCalories += amount
        
        WKInterfaceDevice.current().play(.directionUp)
    }
    
    func addWater(_ amount: Double) {
        let waterEntry = DiaryEntry(
            type: .water,
            value: amount
        )

        StorageManager.shared.addEntry(waterEntry)

        todaysWater += amount

        WKInterfaceDevice.current().play(.notification)
    }

    func playClickHaptic() {
        WKInterfaceDevice.current().play(.click)
    }
}
