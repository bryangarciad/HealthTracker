//
//  AddEntryView.swift
//  HealthTracker Watch App
//
//  ┌───────────────────────────────────────────────────────────────────────┐
//  │  THE "ADD" SCREEN.                                                      │
//  │                                                                         │
//  │  Lets the user pick an amount (preset buttons, +/- buttons, OR the      │
//  │  Digital Crown) and then save it. It works for BOTH water and calories  │
//  │  because it's told which `entryType` to use.                            │
//  │                                                                         │
//  │  Concepts to notice:                                                    │
//  │   • @State — local screen state that this view owns (the chosen amount).│
//  │   • .digitalCrownRotation — a watchOS-only way to turn the crown into   │
//  │     a value.                                                            │
//  │   • WKInterfaceDevice.play(.click) — haptic taps on the wrist.          │
//  └───────────────────────────────────────────────────────────────────────┘
//

import SwiftUI
import WatchKit

struct AddEntryView: View {
    @ObservedObject var healthViewModel: HealthViewModel
    let entryType: EntryType

    // @State is for simple values a view owns itself. When it changes, just
    // this view redraws. `selectedAmount` is what the user is about to log.
    @State private var selectedAmount: Double = 100.0

    // `dismiss` lets us close this screen and go back to the dashboard.
    @Environment(\.dismiss) private var dismiss

    private let presets: [Double] = [200, 300, 500]
    private let fineStep: Double = 10.0

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Image(systemName: entryType.icon)
                    .font(.system(size: 24))
                    .foregroundColor(entryType.color)

                Text("Add \(entryType.rawValue)")
                    .font(.system(size: 12, weight: .medium))

                Text("\(Int(selectedAmount))")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(entryType.color)

                // Preset amount buttons.
                HStack(spacing: 8) {
                    ForEach(presets, id: \.self) { preset in
                        Button {
                            WKInterfaceDevice.current().play(.click)
                            selectedAmount = preset
                        } label: {
                            Text("\(Int(preset))")
                                .font(.system(size: 14, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedAmount == preset ? entryType.color : Color.gray.opacity(0.3))
                                .foregroundColor(selectedAmount == preset ? .black : .white)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Fine +/- adjustment.
                HStack {
                    Button {
                        WKInterfaceDevice.current().play(.click)
                        selectedAmount = max(0, selectedAmount - fineStep)
                    } label: {
                        Image(systemName: "minus.circle.fill").font(.system(size: 24))
                    }
                    .buttonStyle(.plain)

                    Spacer()
                    Text("Adjust").font(.system(size: 12)).foregroundColor(.gray)
                    Spacer()

                    Button {
                        WKInterfaceDevice.current().play(.click)
                        selectedAmount += fineStep
                    } label: {
                        Image(systemName: "plus.circle.fill").font(.system(size: 24))
                    }
                    .buttonStyle(.plain)
                }
                .foregroundColor(.gray)
                .padding(.horizontal, 8)

                // ╔═══════════════════════════════════════════════════════════╗
                // ║  ✏️  EXERCISE 5 — Make the Save button actually save      ║
                // ║                                                           ║
                // ║  The button below currently only closes the screen. Make  ║
                // ║  it log the amount FIRST. Inside the button's action:     ║
                // ║                                                           ║
                // ║   1. Check which type we're adding and call the matching   ║
                // ║      view-model method, passing `selectedAmount`:          ║
                // ║                                                           ║
                // ║         if entryType == .calories {                       ║
                // ║             healthViewModel.addCalories(selectedAmount)    ║
                // ║         } else {                                          ║
                // ║             healthViewModel.addWater(selectedAmount)       ║
                // ║         }                                                 ║
                // ║                                                           ║
                // ║   2. Then `dismiss()` to return to the dashboard (this    ║
                // ║      line is already here).                               ║
                // ╚═══════════════════════════════════════════════════════════╝
                Button {
                    // TODO: Exercise 5 — call the view model to save the amount,
                    //       then dismiss.
                    dismiss()
                } label: {
                    Text("Add")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(selectedAmount > 0 ? entryType.color : Color.gray.opacity(0.3))
                        .foregroundColor(selectedAmount > 0 ? .black : .white)
                        .cornerRadius(12)
                }
                .buttonStyle(.plain)
                .disabled(selectedAmount == 0)
            }
            .padding(.horizontal, 6)
        }
        // Lets the Digital Crown change `selectedAmount` from 0 to 10000.
        .focusable()
        .digitalCrownRotation(
            $selectedAmount,
            from: 0, through: 10000, by: 1,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
    }
}

#Preview {
    NavigationStack {
        AddEntryView(healthViewModel: HealthViewModel(), entryType: .calories)
    }
}
