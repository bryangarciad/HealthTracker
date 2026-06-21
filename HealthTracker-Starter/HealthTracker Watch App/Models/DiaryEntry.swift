//
//  DiaryEntry.swift
//  HealthTracker Watch App
//
//  ┌───────────────────────────────────────────────────────────────────────┐
//  │  MODELS = the "nouns" of your app: the data it works with.              │
//  │                                                                         │
//  │  This file defines TWO things:                                         │
//  │   • EntryType  – an enum: is this entry water, or calories?            │
//  │   • DiaryEntry – a struct: one single logged amount (e.g. "300 ml of   │
//  │     water at 2:45 pm").                                                 │
//  └───────────────────────────────────────────────────────────────────────┘
//

import Foundation
import SwiftUI

// MARK: - EntryType
//
// An `enum` is a type with a fixed set of possible values. Here an entry can
// only ever be `.water` or `.calories` — nothing else. That makes invalid
// states impossible.
//
// We attach extra protocols:
//   • String      → each case has a text value ("water"/"calories").
//   • Codable      → can be saved to / loaded from storage (more on this below).
//   • CaseAllable  → lets us loop over every case if we ever need to.
enum EntryType: String, Codable, CaseIterable {
    case water = "water"
    case calories = "calories"

    // A "computed property" calculates its value each time it is read.
    // Here we give each entry type its own color, so the UI stays consistent:
    // water is always cyan, calories are always orange.
    var color: Color {
        switch self {
        case .water:    return Color.cyan
        case .calories: return Color.orange
        }
    }

    // The SF Symbols icon name used to represent this entry type.
    var icon: String {
        switch self {
        case .water:    return "drop.fill"
        case .calories: return "flame.fill"
        }
    }
}

// MARK: - DiaryEntry
//
// A `struct` groups related values together. One DiaryEntry = one thing the
// user logged.
//
//   • Identifiable → gives each entry a unique `id`. SwiftUI needs this to
//     tell entries apart in lists.
//   • Codable      → Swift can automatically convert this struct to/from JSON
//     so we can store it on the device. (See StorageManager.swift.)
struct DiaryEntry: Identifiable, Codable {
    let id: UUID          // unique identifier
    let type: EntryType   // water or calories
    let value: Double     // how much (ml or kcal)
    let timestamp: Date   // when it was logged

    // A custom initializer with DEFAULT values. Because `id` and `timestamp`
    // have defaults, the rest of the app can create an entry by writing just:
    //     DiaryEntry(type: .water, value: 300)
    // and Swift fills in a fresh id and the current date for us.
    init(id: UUID = UUID(), type: EntryType, value: Double, timestamp: Date = Date()) {
        self.id = id
        self.type = type
        self.value = value
        self.timestamp = timestamp
    }
}
