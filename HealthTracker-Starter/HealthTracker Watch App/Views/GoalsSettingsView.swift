//
//  GoalsSettingsView.swift
//  HealthTracker Watch App
//
//  ┌───────────────────────────────────────────────────────────────────────┐
//  │  THE GOALS SCREEN.                                                      │
//  │                                                                         │
//  │  Lets the user pick their daily calorie and water targets, then save.   │
//  │  This screen is complete — read it to see a second example of @State    │
//  │  and how a view sends data BACK to the view model (updateGoals).        │
//  └───────────────────────────────────────────────────────────────────────┘
//

import SwiftUI

struct GoalsSettingsView: View {
    @ObservedObject var viewModel: HealthViewModel
    @Environment(\.dismiss) private var dismiss

    // We copy the current goals into local @State so the user can change them
    // freely; nothing is saved until they tap "Save Goals".
    @State private var caloriesGoal: Double
    @State private var waterGoal: Double

    private let caloriesPresets: [Double] = [1500, 2000, 2500, 3000]
    private let waterPresets: [Double] = [1500, 2000, 2500, 3000]

    // A custom init so we can seed the @State from the view model's values.
    // The leading underscore (_caloriesGoal) sets the State's initial value.
    init(viewModel: HealthViewModel) {
        self.viewModel = viewModel
        _caloriesGoal = State(initialValue: viewModel.goals.dailyCaloriesGoal)
        _waterGoal = State(initialValue: viewModel.goals.dailyWaterGoal)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                goalSection(
                    title: "Calories Goal",
                    icon: "flame.fill",
                    color: .orange,
                    unit: "kcal",
                    value: caloriesGoal,
                    presets: caloriesPresets,
                    onSelect: { caloriesGoal = $0 }
                )

                Divider().background(Color.gray.opacity(0.3))

                goalSection(
                    title: "Water Goal",
                    icon: "drop.fill",
                    color: .cyan,
                    unit: "ml",
                    value: waterGoal,
                    presets: waterPresets,
                    onSelect: { waterGoal = $0 }
                )

                Button {
                    viewModel.updateGoals(calories: caloriesGoal, water: waterGoal)
                    dismiss()
                } label: {
                    Text("Save Goals")
                        .font(.system(size: 14, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
            }
            .padding(8)
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Reusable section for one goal (calories or water).
    private func goalSection(
        title: String,
        icon: String,
        color: Color,
        unit: String,
        value: Double,
        presets: [Double],
        onSelect: @escaping (Double) -> Void
    ) -> some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: icon).foregroundColor(color)
                Text(title).font(.system(size: 13, weight: .medium))
                Spacer()
            }

            Text("\(Int(value)) \(unit)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(color)

            HStack(spacing: 6) {
                ForEach(presets, id: \.self) { preset in
                    Button {
                        onSelect(preset)
                    } label: {
                        Text("\(Int(preset))")
                            .font(.system(size: 11, weight: .medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(value == preset ? color : color.opacity(0.2))
                            .foregroundColor(value == preset ? .black : color)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GoalsSettingsView(viewModel: HealthViewModel())
    }
}
