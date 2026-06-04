import Combine
import Foundation

// Singleton Pattern
class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    private let storage = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private enum Keys {
        static let diaryEntries = "diary_entries"
    }
    
    // MARK: - Entries Business Logic
    func saveEntries(_ entries: [DiaryEntry]) {
        // Try to encode and if things go south just return nil
        if let encoded = try? encoder.encode(entries) {
            storage.set(encoded, forKey: Keys.diaryEntries)
        }
    }
    
    func loadEntries() -> [DiaryEntry] {
        guard let rawJsonData = storage.data(forKey: Keys.diaryEntries),
              let diaryEntries = try? decoder.decode([DiaryEntry].self, from: rawJsonData) else {
                  return []
              }
        return diaryEntries
    }
    
    func addEntry(_ entry: DiaryEntry) {
        var allTimeEntries = loadEntries()
        allTimeEntries.append(entry)
        self.saveEntries(allTimeEntries)
    }
    
    func getTodaysEntries() -> [DiaryEntry] {
        let entries = loadEntries()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return entries.filter { entry in
            calendar.isDate(entry.timestamp, inSameDayAs: today)
        }
    }
    
    func getTodayTotal(for type: EntryType) -> Double {
        self.getTodaysEntries()
            .filter { $0.type == type }
            .reduce(0) { $0 + $1.value }
    }
}
