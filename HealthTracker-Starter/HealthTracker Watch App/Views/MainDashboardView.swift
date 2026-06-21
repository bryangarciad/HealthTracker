//
//  MainDashboardView.swift
//  HealthTracker Watch App
//
//  ┌───────────────────────────────────────────────────────────────────────┐
//  │  THE HOME SCREEN.                                                       │
//  │                                                                         │
//  │  It shows the two progress rings, the two "quick add" buttons, and a    │
//  │  link to the Goals screen. Notice it reads everything from the view     │
//  │  model and contains NO logic of its own — that's the MVVM pattern.      │
//  │                                                                         │
//  │  This screen is complete. As you finish Exercises 1–3 you'll watch the  │
//  │  rings here come to life.                                               │
//  └───────────────────────────────────────────────────────────────────────┘
//

import SwiftUI

struct MainDashboardView: View {

    // @ObservedObject (not @StateObject): this screen RECEIVES the view model
    // that ContentView created. It watches it for changes and redraws when
    // any @Published value updates.
    @ObservedObject var healthViewModel: HealthViewModel

    private let ringSize = 60.0

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Header
                Text("Today")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.gray)

                // The two rings, side by side.
                HStack(spacing: 16) {
                    ringColumn(
                        progress: healthViewModel.caloriesProgress,
                        current: healthViewModel.todaysCalories,
                        goal: healthViewModel.goals.dailyCaloriesGoal,
                        type: .calories
                    )

                    ringColumn(
                        progress: healthViewModel.waterProgress,
                        current: healthViewModel.todaysWater,
                        goal: healthViewModel.goals.dailyWaterGoal,
                        type: .water
                    )
                }

                // The two "quick add" buttons. Each NavigationLink pushes an
                // AddEntryView for the matching entry type.
                HStack(spacing: 12) {
                    NavigationLink {
                        AddEntryView(healthViewModel: healthViewModel, entryType: .calories)
                    } label: {
                        QuickAddButton(icon: EntryType.calories.icon, label: "Calories", color: EntryType.calories.color)
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        AddEntryView(healthViewModel: healthViewModel, entryType: .water)
                    } label: {
                        QuickAddButton(icon: EntryType.water.icon, label: "Water", color: EntryType.water.color)
                    }
                    .buttonStyle(.plain)
                }

                // Link to the Goals settings screen.
                NavigationLink {
                    GoalsSettingsView(viewModel: healthViewModel)
                } label: {
                    HStack {
                        Image(systemName: "gearshape.fill").font(.system(size: 12))
                        Text("Goals").font(.system(size: 12))
                    }
                    .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
            .frame(maxWidth: .infinity)
        }
        // When showQuoteOverlay flips to true, the motivational quote card
        // appears on top of the whole screen.
        .overlay {
            if healthViewModel.showQuoteOverlay {
                QuoteOverlayView(
                    quote: healthViewModel.currentQuote,
                    isLoading: healthViewModel.isLoadingQuote,
                    onDismiss: { healthViewModel.showQuoteOverlay = false }
                )
            }
        }
    }

    // A small helper that builds one ring + its numbers. Extracting repeated
    // UI into a function keeps `body` readable.
    private func ringColumn(progress: Double, current: Double, goal: Double, type: EntryType) -> some View {
        VStack(spacing: 6) {
            ProgressRingView(progress: progress, icon: type.icon, color: type.color, size: ringSize)

            Text("\(Int(current))")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(type.color)

            Text("/ \(Int(goal))")
                .font(.system(size: 9, design: .rounded))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    NavigationStack {
        MainDashboardView(healthViewModel: HealthViewModel())
    }
}
