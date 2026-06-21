//
//  ContentView.swift
//  HealthTracker Watch App
//
//  ┌───────────────────────────────────────────────────────────────────────┐
//  │  THE ROOT VIEW                                                          │
//  │                                                                         │
//  │  ContentView is the first view shown inside the app's window. Its job   │
//  │  here is small but important:                                           │
//  │                                                                         │
//  │   1. CREATE the view model (the "brain" that holds all our data).       │
//  │   2. Wrap everything in a NavigationStack so we can push new screens     │
//  │      (like "Add Water" or "Goals") on top of each other.                │
//  │   3. Show the MainDashboardView as the starting screen.                 │
//  └───────────────────────────────────────────────────────────────────────┘
//

import SwiftUI

struct ContentView: View {

    // @StateObject means: "This view OWNS this object and keeps it alive for
    // as long as the view exists." We create the HealthViewModel exactly once
    // here, then pass it down to the child screens.
    //
    // Rule of thumb: the screen that CREATES a view model uses @StateObject.
    // Screens that only RECEIVE it use @ObservedObject (you'll see that later).
    @StateObject private var healthViewModel = HealthViewModel()

    var body: some View {
        // NavigationStack lets us navigate forward to other screens and back.
        NavigationStack {
            MainDashboardView(healthViewModel: healthViewModel)
        }
        .onAppear {
            // Every time the dashboard appears, reload today's totals so the
            // rings show the latest numbers.
            healthViewModel.refreshDailyTotals()
        }
    }
}

#Preview {
    ContentView()
}
