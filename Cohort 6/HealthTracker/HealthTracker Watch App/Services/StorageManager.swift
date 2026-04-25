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
    
    // MARK: - Functions
    func saveEntries(_ entries: [DiaryEntry]) {
        if let encodedeEntries = try? encoder.encode(entries) {
            defaults.set(encodedeEntries, forKey: Keys.diaryEntries)
        }
    }
    
    func loadEntries() -> [DiaryEntry] {
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
}

