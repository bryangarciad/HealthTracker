import SwiftUI

struct MainDashboardView: View {
    @ObservedObject var viewModel: HealtTrackerViewModel
    
    let currentActivity: ActivityType?

    var body: some View  {
        ScrollView {
            VStack(spacing: 16) {
                Text("Today")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            // Rings Section
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
            
            // Quick Action Buttons
            HStack(spacing: 12) {
                NavigationLink(destination: AddEntryView(viewModel: viewModel, entryType: .water)) {
                    QuickAddButton(
                        icon: "plus",
                       label: EntryType.water.displayName,
                       color: EntryType.water.color
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: AddEntryView(viewModel: viewModel, entryType: .calories)) {
                    QuickAddButton(
                        icon: "plus",
                       label: EntryType.calories.displayName,
                       color: EntryType.calories.color
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Settings button
            NavigationLink(destination: GoalsSettingsView(viewModel: viewModel)) {
                HStack {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 12))
                    Text("Goals")
                        .font(.system(size: 12))
                }.foregroundColor(.gray)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 4)
            
            // Heart Rate Card Section
            HeartRateCardView(viewModel: viewModel)
                .padding(.top, 8)
        }
        .overlay() {
            if viewModel.showMotivationalQuote {
                ZStack {
                    Color.black.opacity(0.85)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 12) {
                        Image(systemName: "quote.opening")
                            .font(.title3)
                            .foregroundColor(.yellow)
                        
                        Text(viewModel.currentQuote?.quote ?? "")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(4)
                        
                        Text("-- \(viewModel.currentQuote?.author ?? "")")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 12)
                }
            }
        }
        .onAppear {
            // Refresh data when view appears
            viewModel.refreshTodaysData()
        }
 
    }
}

#Preview {
    MainDashboardView(viewModel: HealtTrackerViewModel(), currentActivity: .automotive)
}

