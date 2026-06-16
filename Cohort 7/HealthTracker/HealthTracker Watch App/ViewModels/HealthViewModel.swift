import Foundation
import Combine
import WatchKit

class HealthViewModel: ObservableObject {

    // MARK: - Published Variables
    @Published var todaysWater: Double = 0
    @Published var todaysCalories: Double = 0
    
    @Published var goals: UserGoals
    
    @Published var currentQuote: MotivationalQuote?
    @Published var isLoadingQuote: Bool = false
    @Published var showQuoteOverlay: Bool = false
    
    @Published var useHealthKit: Bool = true
    
    @Published var currentHearthRate: Double = 0
    @Published var isHealthKitAuth: Bool = false
    
    
    var caloriesProgress: Double {
        min(todaysCalories / goals.dailyCaloriesGoal, 1.0)
    }
    
    /// Water progress (0.0 to 1.0)
    var waterProgress: Double {
        min(todaysWater / goals.dailyWaterGoal, 1.0)
    }
    
    
    
    // MARK: - Services/Managers
    internal let storageManager = StorageManager.shared
    internal let motivationalQuoteService = MotivationalQuoteService.shared
    internal let healthStoreDataManager = HealthStoreDataManager.shared
    
    init() {
        self.goals = storageManager.loadCurrentGoals()
        refreshDailyTotals()
    }
    
    // MARK: - Methods Diary Entries
    func refreshDailyTotals() {
        Task {
            await refreshTodaysDataAsync()
        }
    }
    
    func refreshTodaysDataAsync() async {
        if useHealthKit {
            do {
                let calories = try await healthStoreDataManager.getTodaysTotal(for: .calories)
                let water = try await healthStoreDataManager.getTodaysTotal(for: .water)
                
                await MainActor.run {
                    todaysWater = water
                    todaysCalories = calories
                }
                
                print("UI should be update by now")
            } catch {
                // this section is aka the erro handling
                await MainActor.run {
                    todaysCalories = storageManager.getTodayTotal(for: .calories)
                    todaysWater = storageManager.getTodayTotal(for: .water)
                }
            }
        } else {
            await MainActor.run {
                todaysCalories = storageManager.getTodayTotal(for: .calories)
                todaysWater = storageManager.getTodayTotal(for: .water)
            }
            print("Loaded data in UI from local storage")
        }
    }
    
    // MARK: - Methods Goals
    func updateGoals(calories: Double, water: Double) {
        goals = UserGoals(
            dailyCaloriesGoal: calories, dailyWaterGoal: water
        )
        storageManager.saveNewGoals(goals)
        WKInterfaceDevice.current().play(.success)
    }

    func addCalories(_ amount: Double) {
        let entry = DiaryEntry(
            type: .calories,
            value: amount
        )
        //storageManager.addEntry(entry)
        
        fetchQuoteAfterEntry()
    }
    
    func addWater(_ amount: Double) {
        let entry = DiaryEntry(
            type: .water,
            value: amount
        )
        //storageManager.addEntry(entry)
        
        fetchQuoteAfterEntry()
    }

    // MARK: - Methods Motivational Quotes
    func fetchQuoteAfterEntry() {
        isLoadingQuote = true
        showQuoteOverlay = true
        
        Task {
            currentQuote = await motivationalQuoteService.fetchQuote()
            isLoadingQuote = false
            
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            showQuoteOverlay = false
        }
    }
}
