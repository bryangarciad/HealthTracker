import Foundation
import Combine

// Singleton
class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    // MARK: - Keys
    private enum Keys {
        static let diaryEntries = "diary_entries"
        static let userGoals = "user_goals"
    }

    // MARK: - Private Props
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Diary Entries Section
    func saveEntries(_ entries: [DiaryEntry]) {
        if let encodedeEntries = try? encoder.encode(entries) {
            defaults.set(encodedeEntries, forKey: Keys.diaryEntries)
        }
    }
    
    func loadEntries() -> [DiaryEntry] { // loading all time entries
        guard let encodedDiaryEntries = defaults.data(forKey: Keys.diaryEntries),
              let diaryEntries = try? decoder.decode([DiaryEntry].self, from: encodedDiaryEntries) else {
            return []
        }
        
        return diaryEntries
    }
    
    func addEntry(_ entry: DiaryEntry) {
        var entries = loadEntries() // we get all entries from storage
        entries.append(entry)
        saveEntries(entries)
    }
    
    // MARK: - User Goals Section
    
    func saveGoals(_ goals: UserGoals) {
        if let encodedGoals = try? encoder.encode(goals) {
            defaults.set(encoder, forKey: Keys.userGoals)
        }
    }
    
    func loadGoals() -> UserGoals {
        guard let encodedGoals = defaults.data(forKey: Keys.userGoals),
              let userGoals = try? decoder.decode(UserGoals.self, from: encodedGoals) else {
            return UserGoals.defaultGoals
        }
        
        return userGoals
    }
    
    // MARK: - Data Presentation layer
    func getTodaysEntries() -> [DiaryEntry] {
        let allTimeEntries = loadEntries()

        let calendar = Calendar.current
        let startOfDayToday = calendar.startOfDay(for: Date()) // Start Of The day
        
        return allTimeEntries.filter { entry in
            calendar.isDate(entry.timestamp, inSameDayAs: startOfDayToday)
        }
    }
    
    func getTodaysTotal(for type: EntryType) -> Double {
        getTodaysEntries()
            .filter { $0.type == type }
            .reduce(0) {$0 + $1.value}
    }
}

