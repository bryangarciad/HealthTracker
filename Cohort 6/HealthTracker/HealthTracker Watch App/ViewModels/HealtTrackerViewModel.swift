import SwiftUI
import Combine
import Foundation

@MainActor
class HealtTrackerViewModel: ObservableObject {
    @Published var goals: UserGoals
    @Published var todaysCalories: Double = 0
    @Published var todaysWater: Double = 0
    
    // This is a controller variable
    @Published var useHealthKit: Bool = false
    @Published var hkAuthStatus: String = "Not Requested"

    
    var caloriesProgress: Double {
        min(todaysCalories / goals.dailyCaloriesGoal, 1.0)
    }
    
    var waterProgress: Double {
        min(todaysWater / goals.dailyWaterGoal, 1.0)
    }
    
    // MARK: - View Model For Storage Manager
    private let storageManager = StorageManager.shared
    private let healthKitManager = HealthKitManager.shared
    
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
        
        if useHealthKit {
            Task {
                do {
                    try await healthKitManager.addEntry(entry)
                    await refreshTodaysData()
                } catch {
                    print("Error adding calories to healthkit")
                }
            }
            return
        }
        
        storageManager.addEntry(entry)
        
        todaysCalories += amount
    }
    
    func addWater(_ amount: Double) {
        let entry = DiaryEntry(type: .water, value: amount)
        
        if useHealthKit {
            Task {
                do {
                    try await healthKitManager.addEntry(entry)
                    await refreshTodaysData()
                } catch {
                    print("Error adding calories to healthkit")
                }
            }
            return
        }
        
        storageManager.addEntry(entry)
        
        todaysWater += amount
    }
    
    func refreshTodaysData() async {
        if useHealthKit {
            do {
                todaysCalories = try await healthKitManager.getTodaysTotal(for: .calories)
                todaysWater = try await healthKitManager.getTodaysTotal(for: .water)
            } catch {
                todaysCalories = storageManager.getTodaysTotal(for: .calories)
                todaysWater = storageManager.getTodaysTotal(for: .water)
            }
        } else {
            todaysCalories = storageManager.getTodaysTotal(for: .calories)
            todaysWater = storageManager.getTodaysTotal(for: .water)
        }
    }
    
    func refreshTodaysData() {
        Task {
            await refreshTodaysData()
        }
    }
    
    // MARK: - HealthKit
    
    func toggleUseHealthKith() {
        useHealthKit = !useHealthKit
    }
    
    func requestHealthKitAuth() async {
        do {
            try await healthKitManager.requestAuth()
            hkAuthStatus = "Authorized"
            await refreshTodaysData()
        } catch {
            hkAuthStatus = "Failed Auth"
        }
    }
    
}
