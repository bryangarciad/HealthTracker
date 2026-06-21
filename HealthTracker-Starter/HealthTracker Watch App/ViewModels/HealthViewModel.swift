//
//  HealthViewModel.swift
//  HealthTracker Watch App
//
//  ┌───────────────────────────────────────────────────────────────────────┐
//  │  THE VIEW MODEL  (the "VM" in MVVM)                                     │
//  │                                                                         │
//  │  This is the BRAIN of the app. The views (the screens) stay "dumb":     │
//  │  they just display whatever the view model tells them and forward       │
//  │  button taps back to it. All the real logic lives here.                 │
//  │                                                                         │
//  │  KEY IDEAS                                                              │
//  │   • ObservableObject + @Published: when a @Published value changes,    │
//  │     every view watching it AUTOMATICALLY redraws. This is how the       │
//  │     rings update the instant you log water or calories.                 │
//  │   • The view model talks to the StorageManager and the quote service;   │
//  │     the views never touch storage directly.                            │
//  └───────────────────────────────────────────────────────────────────────┘
//

import Foundation
import Combine   // needed for ObservableObject / @Published
import WatchKit

class HealthViewModel: ObservableObject {

    // MARK: - Published State
    // Anything marked @Published, when changed, tells the UI to refresh.
    @Published var todaysWater: Double = 0
    @Published var todaysCalories: Double = 0

    @Published var goals: UserGoals

    @Published var currentQuote: MotivationalQuote?
    @Published var isLoadingQuote: Bool = false
    @Published var showQuoteOverlay: Bool = false

    // MARK: - Services
    // The view model holds references to the shared helpers it needs.
    private let storageManager = StorageManager.shared
    private let quoteService = MotivationalQuoteService.shared

    // MARK: - Init
    init() {
        // Load the user's saved goals (or defaults) as soon as we're created.
        self.goals = storageManager.loadCurrentGoals()
        refreshDailyTotals()
    }

    // MARK: - Progress (computed properties)
    //
    // ╔═══════════════════════════════════════════════════════════════════════╗
    // ║  ✏️  EXERCISE 2 — Calculate progress toward each goal                 ║
    // ║                                                                       ║
    // ║  Each ring needs a number between 0.0 (empty) and 1.0 (full).         ║
    // ║  progress = how much you've logged ÷ your goal.                       ║
    // ║                                                                       ║
    // ║  Example: 500 ml logged with a 2000 ml goal → 500 / 2000 = 0.25.      ║
    // ║                                                                       ║
    // ║  Watch out for TWO things:                                            ║
    // ║   • If you log MORE than the goal you'd get a number above 1.0, which ║
    // ║     would over-fill the ring. Use `min(value, 1.0)` to cap it at 1.0. ║
    // ║                                                                       ║
    // ║  Replace each `return 0` below with the real formula, e.g.:           ║
    // ║     min(todaysCalories / goals.dailyCaloriesGoal, 1.0)                ║
    // ╚═══════════════════════════════════════════════════════════════════════╝

    /// How full the calories ring should be (0.0 ... 1.0).
    var caloriesProgress: Double {
        // TODO: Exercise 2 — return calories logged ÷ calories goal, capped at 1.0
        return 0
    }

    /// How full the water ring should be (0.0 ... 1.0).
    var waterProgress: Double {
        // TODO: Exercise 2 — return water logged ÷ water goal, capped at 1.0
        return 0
    }

    // MARK: - Loading Today's Totals

    /// Reload today's water & calories totals from storage and refresh the UI.
    func refreshDailyTotals() {
        todaysCalories = storageManager.getTodayTotal(for: .calories)
        todaysWater = storageManager.getTodayTotal(for: .water)
    }

    // MARK: - Adding Entries
    //
    // ╔═══════════════════════════════════════════════════════════════════════╗
    // ║  ✏️  EXERCISE 3 — Save a new entry                                    ║
    // ║                                                                       ║
    // ║  When the user taps "Add", AddEntryView calls addCalories(...) or     ║
    // ║  addWater(...). Your job: actually SAVE the amount and update the     ║
    // ║  on-screen total.                                                     ║
    // ║                                                                       ║
    // ║  Inside `addEntry(type:amount:)` below:                               ║
    // ║   1. Build a DiaryEntry:                                              ║
    // ║          let entry = DiaryEntry(type: type, value: amount)            ║
    // ║   2. Save it:  storageManager.addEntry(entry)                         ║
    // ║   3. Refresh the totals so the ring updates:  refreshDailyTotals()    ║
    // ║                                                                       ║
    // ║  (The reward-quote call is already wired up for you at the end.)      ║
    // ╚═══════════════════════════════════════════════════════════════════════╝
    private func addEntry(type: EntryType, amount: Double) {
        // TODO: Exercise 3 — create the entry, save it, then refresh totals.


        // Already done for you: show a motivational quote as a little reward.
        fetchQuoteAfterEntry()
    }

    /// Called by AddEntryView when the user logs calories.
    func addCalories(_ amount: Double) {
        addEntry(type: .calories, amount: amount)
    }

    /// Called by AddEntryView when the user logs water.
    func addWater(_ amount: Double) {
        addEntry(type: .water, amount: amount)
    }

    // MARK: - Goals

    /// Save new daily goals and give a little success haptic tap on the wrist.
    func updateGoals(calories: Double, water: Double) {
        goals = UserGoals(dailyCaloriesGoal: calories, dailyWaterGoal: water)
        storageManager.saveNewGoals(goals)
        WKInterfaceDevice.current().play(.success)  // haptic feedback
    }

    // MARK: - Motivational Quote

    /// Show a loading overlay, fetch a quote, then auto-hide after 3 seconds.
    func fetchQuoteAfterEntry() {
        isLoadingQuote = true
        showQuoteOverlay = true

        // `Task { }` runs asynchronous work without blocking the UI.
        Task {
            currentQuote = await quoteService.fetchQuote()
            isLoadingQuote = false

            // Wait 3 seconds, then hide the overlay automatically.
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            showQuoteOverlay = false
        }
    }
}
