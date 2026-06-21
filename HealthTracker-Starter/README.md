# ⌚️ Health Tracker — Apple Watch App (Starter Project)

Welcome! 👋 This is a **starter project** for the Health Tracker watchOS app. Most of
the app is already built and explained with lots of comments — your job is to fill in
**6 small pieces** (marked `✏️ EXERCISE`) to make the features actually work.

The app **already builds and runs** before you change anything. As you complete each
exercise, more of the app comes to life. You'll never start from a blank screen.

## 📋 Required Student Work

**Files the student must modify:**

| File | What must be completed |
|------|------------------------|
| `Views/Components/ProgressRingView.swift` | **Exercise 1** — Add the foreground `Circle` that uses `.trim(from:to:)`, `.stroke`, `.rotationEffect`, and `.animation` so the rings visually fill toward the goal. |
| `ViewModels/HealthViewModel.swift` | **Exercise 2** — Implement the `caloriesProgress` and `waterProgress` computed properties (logged ÷ goal, capped at `1.0` with `min`). |
| `ViewModels/HealthViewModel.swift` | **Exercise 3** — Complete `addEntry(type:amount:)`: build a `DiaryEntry`, save it via `storageManager.addEntry(_:)`, then call `refreshDailyTotals()`. |
| `Services/StorageManager.swift` | **Exercise 4** — Implement `getTodayTotal(for:)` using `.filter` + `.reduce` to sum today's matching entries. |
| `Views/AddEntryView.swift` | **Exercise 5** — Wire the **Add** button to call `addCalories`/`addWater` on the view model before `dismiss()`. |
| `Services/MotivationalQuoteService.swift` | **Exercise 6 (bonus)** — Implement `fetchQuote()` with `async`/`await`, `URLSession`, JSON decoding, and a `do/catch` fallback. |

*(All other files are complete and provided as worked examples to read and learn from.)*

**Learning objectives covered:**

- Build and reason about a **SwiftUI** layout (`ZStack`/`VStack`/`HStack`) and custom drawing with `Shape` modifiers (`.trim`, `.stroke`, `.rotationEffect`, `.animation`).
- Apply the **MVVM** pattern: keep views declarative and move logic into an `ObservableObject` view model.
- Use **`@Published` / `@StateObject` / `@ObservedObject` / `@State`** correctly and explain reactive UI updates.
- Define and use **computed properties**, including guarding a range with `min`.
- Create and persist **`Codable`** model data with **`UserDefaults`** (the singleton storage pattern).
- Transform collections with **higher-order functions** (`filter`, `reduce`).
- Pass data and intent **between a view and its view model**.
- (Bonus) Perform **asynchronous networking** with `async`/`await`, `URLSession`, and JSON decoding, with graceful error handling.

**Estimated time required:**

**~1 hour** for Exercises 1–5 (the core requirement). Up to **2 hours maximum** including Exercise 6 (bonus networking) and time spent reading the commented example files.

## 📱 What the app does

A tiny Apple Watch health diary. You log how much **water** and **calories** you've
had today, watch two **progress rings** fill toward your daily goals, set those goals,
and get a **motivational quote** as a reward each time you log something.

## 🚀 Getting started

1. Open **`HealthTracker.xcodeproj`** in Xcode.
2. At the top, choose any **Apple Watch simulator** (e.g. _Apple Watch Series — 46mm_).
3. Press **▶ Run** (or `⌘R`). The app should launch in the simulator.
4. Tap around: the buttons and goals screen already navigate. The rings are empty and
   logging doesn't save yet — that's what you'll fix.

> 💡 You do **not** need an Apple Watch or a paid developer account. Everything runs in
> the simulator.

## 🧠 Concepts you'll practice

| Area | Where |
|------|-------|
| SwiftUI layout (`VStack`, `HStack`, `ZStack`) | every View |
| Custom drawing with `.trim` / `.stroke` | Exercise 1 |
| Computed properties | Exercise 2 |
| MVVM + `@Published` state | Exercise 2 & 3 |
| Saving data with `UserDefaults` | Exercise 3 & 4 |
| Higher-order functions (`filter`, `reduce`) | Exercise 4 |
| Passing data between views | Exercise 5 |
| `async`/`await` networking (bonus) | Exercise 6 |

## ✅ Your tasks (do them in order)

Each one is marked in the code with a big `✏️ EXERCISE` comment box that explains
exactly what to do. Use Xcode's search (`⌘⇧F`) for the word **`EXERCISE`** to jump to them.

- [ ] **Exercise 1 — Draw the progress arc**
  `Views/Components/ProgressRingView.swift`
  Make the rings actually fill up.

- [ ] **Exercise 2 — Calculate progress**
  `ViewModels/HealthViewModel.swift`
  Compute how full each ring should be (logged ÷ goal).

- [ ] **Exercise 3 — Save a new entry**
  `ViewModels/HealthViewModel.swift`
  Store what the user logs and refresh the totals.

- [ ] **Exercise 4 — Total up today's entries**
  `Services/StorageManager.swift`
  Add up today's matching entries with `filter` + `reduce`.

- [ ] **Exercise 5 — Wire up the Save button**
  `Views/AddEntryView.swift`
  Make the "Add" button send the amount to the view model.

- [ ] **Exercise 6 (bonus) — Fetch a real quote online**
  `Services/MotivationalQuoteService.swift`
  Replace the built-in quote with a live one using `async`/`await`.

## 🎉 How you know it works

After Exercises 1–5, you should be able to:

1. Tap **Water** → pick **300** → **Add**.
2. Land back on the dashboard and see the water ring partly filled and the number = 300.
3. Add more and watch the ring grow. Close and reopen the app — your totals are still
   there (that's persistence!).
4. Open **Goals**, lower your goal, and see the ring fill faster.

## 🗂 Project structure

```
HealthTracker Watch App/
├── Models/         ← the data types (DiaryEntry, UserGoals, MotivationalQuote)
├── ViewModels/     ← HealthViewModel: the "brain" (Exercises 2 & 3)
├── Services/       ← saving data + fetching quotes (Exercises 4 & 6)
└── Views/          ← the screens
    └── Components/  ← small reusable pieces (Exercise 1)
```

## 🆘 Stuck?

- Read the comment box for the exercise — it has the exact code hints.
- Build often (`⌘B`). Fix one exercise, run, see the result, move on.
- Read the files marked _"done for you"_ — they show the same patterns you need.

Good luck, and have fun! 🚀
