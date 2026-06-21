//
//  StorageManager.swift
//  HealthTracker Watch App
//
//  ┌───────────────────────────────────────────────────────────────────────┐
//  │  PERSISTENCE = remembering data even after the app is closed.           │
//  │                                                                         │
//  │  This class saves and loads our data using `UserDefaults`, a simple     │
//  │  built-in key/value store (great for small amounts of data like ours). │
//  │                                                                         │
//  │  It also shows the SINGLETON pattern: there is exactly ONE shared        │
//  │  StorageManager for the whole app, reached via `StorageManager.shared`. │
//  └───────────────────────────────────────────────────────────────────────┘
//

import Foundation

class StorageManager {

    // MARK: - Singleton
    // `shared` is the one and only instance. `private init()` stops anyone
    // from creating their own copy — they MUST use the shared one.
    static let shared = StorageManager()
    private init() {}

    // The actual on-device storage, plus the helpers that turn our Swift
    // structs into JSON data (encoder) and back again (decoder).
    private let storage = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    // Using constants for the storage keys avoids typos. If you mistype a key
    // string somewhere, you'd silently save/load the wrong thing.
    private enum Keys {
        static let diaryEntries = "diary_entries"
        static let userGoals = "user_goals"
    }

    // MARK: - Saving & Loading Entries

    /// Save the FULL list of entries, replacing whatever was stored before.
    func saveEntries(_ entries: [DiaryEntry]) {
        // `try?` means "attempt this; if it fails, give me nil instead of crashing."
        if let encoded = try? encoder.encode(entries) {
            storage.set(encoded, forKey: Keys.diaryEntries)
        }
    }

    /// Load every entry we've ever saved. Returns an empty array if there's
    /// nothing stored yet (e.g. the very first launch).
    func loadEntries() -> [DiaryEntry] {
        guard let rawData = storage.data(forKey: Keys.diaryEntries),
              let entries = try? decoder.decode([DiaryEntry].self, from: rawData) else {
            return []
        }
        return entries
    }

    /// Add ONE new entry: load what's there, append, save it all back.
    func addEntry(_ entry: DiaryEntry) {
        var allEntries = loadEntries()
        allEntries.append(entry)
        saveEntries(allEntries)
    }

    /// Return only the entries that were logged TODAY.
    func getTodaysEntries() -> [DiaryEntry] {
        let entries = loadEntries()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // `.filter` keeps only the items for which the closure returns true.
        return entries.filter { entry in
            calendar.isDate(entry.timestamp, inSameDayAs: today)
        }
    }

    // ╔═══════════════════════════════════════════════════════════════════════╗
    // ║  ✏️  EXERCISE 4 — Add up today's total for one entry type             ║
    // ║                                                                       ║
    // ║  Goal: return the SUM of the `value`s of today's entries that match   ║
    // ║  the given `type` (water OR calories).                                ║
    // ║                                                                       ║
    // ║  Steps:                                                               ║
    // ║   1. Start from `getTodaysEntries()`.                                 ║
    // ║   2. `.filter { $0.type == type }` to keep only matching entries.     ║
    // ║   3. `.reduce(0) { $0 + $1.value }` to add up all their values.       ║
    // ║                                                                       ║
    // ║  `.reduce` walks the list while carrying a running total:             ║
    // ║      $0 = the total so far,  $1 = the current entry.                  ║
    // ║                                                                       ║
    // ║  Replace the placeholder `return 0` below with the real calculation.  ║
    // ╚═══════════════════════════════════════════════════════════════════════╝
    func getTodayTotal(for type: EntryType) -> Double {
        // TODO: Exercise 4 — compute and return the real total.
        return 0
    }

    // MARK: - Saving & Loading Goals

    func saveNewGoals(_ goals: UserGoals) {
        if let encoded = try? encoder.encode(goals) {
            storage.set(encoded, forKey: Keys.userGoals)
        }
    }

    /// Load the user's saved goals, or fall back to sensible defaults.
    func loadCurrentGoals() -> UserGoals {
        guard let rawData = storage.data(forKey: Keys.userGoals),
              let goals = try? decoder.decode(UserGoals.self, from: rawData) else {
            return UserGoals.defaultGoals
        }
        return goals
    }
}
