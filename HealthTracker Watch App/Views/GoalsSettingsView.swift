import SwiftUI

struct GoalSettingsView: View {
    
    @ObservedObject var viewModel: HealthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var caloriesGoal: Double
    @State private var waterGoal: Double
    
    private let pressets: [Double] = [1500, 2000, 2500, 3000]
    
    init(viewModel: HealthViewModel) {
        self.viewModel = viewModel
        _caloriesGoal = State(initialValue:  viewModel.goals.dailyCaloriesGoal)
        _waterGoal = State(initialValue: viewModel.goals.dailyWaterGoal)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack {
                    Image(systemName: EntryType.calories.icon)
                        .foregroundColor(EntryType.calories.color)
                    Text("Calories Goal")
                        .font(.system(size: 13, weight: .medium))
                    
                    Spacer()
                }
                Text("\(Int(caloriesGoal)) Kcal")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
                
                HStack(spacing: 6) {
                    ForEach(pressets, id: \.self) { preset in
                        Button {
                            caloriesGoal = preset
                        } label: {
                            Text("\(Int(preset/1000))K")
                                .font(.system(size: 11, weight: .medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(
                                    caloriesGoal == preset ? Color.orange :
                                        Color.orage.opacity(0.2)
                                )
                                .foregroundColor(
                                    caloriesGoal == preset ? .back : .orange
                                )
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
            
            VStack(spacing: 20) {
                VStack {
                    Image(systemName: EntryType.water.icon)
                        .foregroundColor(EntryType.water.color)
                    Text("Water Goal")
                        .font(.system(size: 13, weight: .medium))
                    
                    Spacer()
                }
                Text("\(Int(waterGoal)) ml")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
                
                HStack(spacing: 6) {
                    ForEach(pressets, id: \.self) { preset in
                        Button {
                            waterGoal = preset
                        } label: {
                            Text("\(Int(waterGoal))ml")
                                .font(.system(size: 11, weight: .medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(
                                    caloriesGoal == preset ? Color.cyan :
                                        Color.cyan.opacity(0.2)
                                )
                                .foregroundColor(
                                    caloriesGoal == preset ? .back : .cyan
                                )
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}
