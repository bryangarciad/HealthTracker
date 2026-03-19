import Foundation
import Combine

// Singleton
class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    // MARK: - Keys
    private enum Keys {
        static let userGoals = "user_goals"
        static let diaryEntries = "diary_entries" // water or calories entries
    }
    
    // MARK: - Private Props
    private let defaults = UserDefaults.standard // This is the storage that we are going to use to store our goals and entries
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Bussines Logic For User Goals
    func saveGoals(_ goals: UserGoals) {
        if let encoded = try? encoder.encode(goals) {
            defaults.set(encoded, forKey: Keys.userGoals)
        }
    }
    
    func loadGoals() -> UserGoals {
        guard let data = defaults.data(forKey: Keys.userGoals), // JSON Encoded String
              let goals = try? decoder.decode(UserGoals.self, from: data) else {
            return UserGoals.defaultGoals
        }
        
        return goals
    }
    
    // entry is either a calories entry or water entry
    func saveEntries(_ entries: [DiaryEntry]) {
        if let encoded = try? encoder.encode(entries) {
            defaults.set(encoded, forKey: Keys.diaryEntries)
        }
    }
    
    func loadEntries() -> [DiaryEntry] {
        guard let data = defaults.data(forKey: Keys.diaryEntries),
              let entries = try? decoder.decode([DiaryEntry].self, from: data) else {
            return []
        }
        
        return entries
    }
    
    func addEntry(_ entry: DiaryEntry) {
        var entries = loadEntries() // 1. we get all entries from the storage
        entries.append(entry) // 2. add the new entry to the group
        saveEntries(entries) // 3. We reconciliate the storage with the new entry added
    }
    
    func getTodaysEntries() -> [DiaryEntry] {
        let entries = loadEntries()
        let calendar = Calendar.current
        // We want to filter entries for todays day (03/18T00:00:00 -> 03/18T23:59:59)
        let today = calendar.startOfDay(for: Date())
        
        return entries.filter { entry in
            calendar.isDate(entry.timestamp, inSameDayAs: today)
        }
    }
    
    func getTodaysTotal(for type: EntryType) -> Double {
        getTodaysEntries()
            .filter { $0.type == type}
            .reduce(0) { $0 + $1.value }
    }
}
