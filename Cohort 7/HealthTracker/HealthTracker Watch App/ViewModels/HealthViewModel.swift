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
    
    // MARK: - Services/Managers
    private let storageManager = StorageManager.shared
    private let motivationalQuoteService = MotivationalQuoteService.shared
    
    
    init() {
        self.goals = storageManager.loadCurrentGoals()
        refreshDailyTotals()
    }
    
    // MARK: - Methods Goals
    func updateGoals(calories: Double, water: Double) {
        goals = UserGoals(
            dailyCaloriesGoal: calories, dailyWaterGoal: water
        )
        storageManager.saveNewGoals(goals)
        WKInterfaceDevice.current().play(.success)
    }
    
    // MARK: - Methods Diary Entries
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
        
        fetchQuoteAfterEntry()
    }
    
    func addWater(_ amount: Double) {
        let entry = DiaryEntry(
            type: .water,
            value: amount
        )
        storageManager.addEntry(entry)
        
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
