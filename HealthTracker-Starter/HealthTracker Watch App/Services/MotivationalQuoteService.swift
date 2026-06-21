//
//  MotivationalQuoteService.swift
//  HealthTracker Watch App
//
//  ┌───────────────────────────────────────────────────────────────────────┐
//  │  NETWORKING = fetching data from the internet.                          │
//  │                                                                         │
//  │  After the user logs water/calories we reward them with a motivational  │
//  │  quote fetched from a free web API. If the internet call fails, we      │
//  │  quietly fall back to one of the built-in quotes below, so the app      │
//  │  never feels broken.                                                    │
//  └───────────────────────────────────────────────────────────────────────┘
//

import Foundation

class MotivationalQuoteService {

    // Singleton — one shared service for the whole app.
    static let shared = MotivationalQuoteService()
    private init() {}

    // MARK: - Config
    private let apiURL = "https://zenquotes.io/api/random"

    // Backup quotes used when there's no internet (or the API is down).
    private let fallbackQuotes: [MotivationalQuote] = [
        MotivationalQuote(quote: "Every step counts towards your goal!", author: "Health Wisdom"),
        MotivationalQuote(quote: "Hydration is the foundation of health.", author: "Wellness Guide"),
        MotivationalQuote(quote: "Small progress is still progress.", author: "Daily Motivation"),
        MotivationalQuote(quote: "Your body deserves the best fuel.", author: "Nutrition Tip"),
        MotivationalQuote(quote: "Consistency beats perfection.", author: "Fitness Coach"),
        MotivationalQuote(quote: "Listen to your body, it knows.", author: "Health Wisdom"),
        MotivationalQuote(quote: "One glass at a time builds oceans.", author: "Hydration Tip"),
        MotivationalQuote(quote: "Energy comes from what you consume.", author: "Nutrition Guide")
    ]

    /// Pick a random backup quote. Used as the safety net everywhere.
    func getRandomFallbackQuote() -> MotivationalQuote {
        fallbackQuotes.randomElement() ?? fallbackQuotes[0]
    }

    // ╔═══════════════════════════════════════════════════════════════════════╗
    // ║  ✏️  EXERCISE 6 (BONUS) — Fetch a real quote from the internet        ║
    // ║                                                                       ║
    // ║  Right now this always returns a built-in fallback quote, so the app  ║
    // ║  works without any networking. Your bonus task is to fetch a LIVE     ║
    // ║  quote from `apiURL` and only fall back if something goes wrong.      ║
    // ║                                                                       ║
    // ║  `async`/`await` lets us wait for a slow web request WITHOUT freezing  ║
    // ║  the screen. Outline of what to add inside the `do { }` block:        ║
    // ║                                                                       ║
    // ║   1. guard let url = URL(string: apiURL) else { return fallback }     ║
    // ║   2. let (data, _) = try await URLSession.shared.data(from: url)      ║
    // ║   3. let decoded = try JSONDecoder()                                  ║
    // ║          .decode([MotivationalQuote.APIResponse].self, from: data)    ║
    // ║   4. if let first = decoded.first {                                   ║
    // ║          return MotivationalQuote(quote: first.q, author: first.a)    ║
    // ║      }                                                                ║
    // ║                                                                       ║
    // ║  Anything that `throw`s jumps to the `catch` block, where we return   ║
    // ║  a fallback quote so the user still sees something.                   ║
    // ╚═══════════════════════════════════════════════════════════════════════╝
    func fetchQuote() async -> MotivationalQuote {
        // TODO: Exercise 6 — replace this with a real network call wrapped in a
        //       do { ... } catch { ... } block, as described above. For now we
        //       always return a built-in fallback quote so the app works.
        return getRandomFallbackQuote()
    }
}
