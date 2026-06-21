//
//  HealthTrackerApp.swift
//  HealthTracker Watch App
//
//  ┌───────────────────────────────────────────────────────────────────────┐
//  │  THE APP ENTRY POINT                                                    │
//  │                                                                         │
//  │  Every SwiftUI app has exactly ONE type marked with @main. This is     │
//  │  where the operating system starts your app. Think of it as the        │
//  │  "front door" of the program.                                          │
//  │                                                                         │
//  │  You normally do NOT need to change this file. It just says:           │
//  │  "When the app launches, show a window containing ContentView."        │
//  └───────────────────────────────────────────────────────────────────────┘
//

import SwiftUI

@main
struct HealthTracker_Watch_AppApp: App {
    // `body` describes the scene(s) the app shows.
    // On watchOS a `WindowGroup` is the single screen the user sees.
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
