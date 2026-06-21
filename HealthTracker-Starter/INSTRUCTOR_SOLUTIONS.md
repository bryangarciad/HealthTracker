# 🔑 Instructor Solutions — Health Tracker Starter

> **For the instructor only.** Delete this file before handing the repo to the student
> (`git rm INSTRUCTOR_SOLUTIONS.md && git commit`), or keep it on a private branch.

These are reference answers for the 6 exercises. Multiple correct variations exist; the
key concept being assessed is noted for each.

---

### Exercise 1 — `Views/Components/ProgressRingView.swift`
*Concept: custom drawing, `.trim`, animation.* Paste between LAYER 1 and the icon:

```swift
Circle()
    .trim(from: 0, to: progress)
    .stroke(
        color,
        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
    )
    .rotationEffect(.degrees(-90))
    .animation(.easeInOut, value: progress)
```

### Exercise 2 — `ViewModels/HealthViewModel.swift`
*Concept: computed properties, division, capping with `min`.*

```swift
var caloriesProgress: Double {
    min(todaysCalories / goals.dailyCaloriesGoal, 1.0)
}

var waterProgress: Double {
    min(todaysWater / goals.dailyWaterGoal, 1.0)
}
```

### Exercise 3 — `ViewModels/HealthViewModel.swift`
*Concept: creating a model, calling the storage layer, refreshing published state.*

```swift
private func addEntry(type: EntryType, amount: Double) {
    let entry = DiaryEntry(type: type, value: amount)
    storageManager.addEntry(entry)
    refreshDailyTotals()

    fetchQuoteAfterEntry()
}
```

### Exercise 4 — `Services/StorageManager.swift`
*Concept: `filter` + `reduce`.*

```swift
func getTodayTotal(for type: EntryType) -> Double {
    getTodaysEntries()
        .filter { $0.type == type }
        .reduce(0) { $0 + $1.value }
}
```

### Exercise 5 — `Views/AddEntryView.swift`
*Concept: a view forwarding user intent to the view model.*

```swift
Button {
    if entryType == .calories {
        healthViewModel.addCalories(selectedAmount)
    } else {
        healthViewModel.addWater(selectedAmount)
    }
    dismiss()
} label: { ... }
```

### Exercise 6 (bonus) — `Services/MotivationalQuoteService.swift`
*Concept: `async`/`await`, `URLSession`, JSON decoding, error handling.*

```swift
func fetchQuote() async -> MotivationalQuote {
    guard let url = URL(string: apiURL) else { return getRandomFallbackQuote() }
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode([MotivationalQuote.APIResponse].self, from: data)
        if let first = decoded.first {
            return MotivationalQuote(quote: first.q, author: first.a)
        }
    } catch {
        print("Quote API error: \(error.localizedDescription)")
    }
    return getRandomFallbackQuote()
}
```

---

## Design notes
- HealthKit and CoreMotion (from the full class project) were intentionally removed so
  the project runs in the **simulator with no paid developer team or device**. The
  same MVVM/persistence/networking concepts are preserved through local `UserDefaults`
  storage and the quote API.
- The project uses Xcode's **file-system-synchronized groups**, so new `.swift` files
  added to the `HealthTracker Watch App` folder are picked up automatically — no need
  to register them in the project file.
