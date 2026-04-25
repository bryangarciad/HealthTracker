import SwiftUI

struct MainDashboardView: View {
    @ObservedObject var viewModel: HealtTrackerViewModel
    
    var body: some View  {
        ScrollView {
            VStack(spacing: 16) {
                Text("Today")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 20) {
                VStack(spacing: 6) {
                    // Water Ring,
                    ProgressRingView(
                        color: EntryType.water.color,
                        progress: viewModel.waterProgress,
                        icon: EntryType.water.icon,
                        size: 55
                    )
                    
                    Text("\(Int(viewModel.todaysWater))")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(EntryType.water.color)
                    
                    Text("\(Int(viewModel.goals.dailyWaterGoal)) ml")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 6) {
                    ProgressRingView(
                        color: EntryType.calories.color,
                        progress: viewModel.caloriesProgress,
                        icon: EntryType.calories.icon,
                        size: 55
                    )
                    

                    Text("\(Int(viewModel.todaysCalories))")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(EntryType.calories.color)
                    

                    Text("\(Int(viewModel.goals.dailyCaloriesGoal)) kcal")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    MainDashboardView(viewModel: HealtTrackerViewModel())
}

