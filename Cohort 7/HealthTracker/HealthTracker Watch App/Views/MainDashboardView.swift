import SwiftUI

struct MainDashboardView: View {
    @ObservedObject var healthViewModel: HealthViewModel
    
    let ringSize = 60.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Header
                Text("Today")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.gray)
                
                // MARK: - Progress Rings Row
                HStack(spacing: 16) {
                    VStack (spacing: 6) {
                        ProgressRingView(
                            progress: healthViewModel.caloriesProgress,
                            icon: EntryType.calories.icon,
                            color: EntryType.calories.color,
                            size: ringSize
                        )
                    }
                    
                    VStack (spacing: 6) {
                        ProgressRingView(
                            progress: healthViewModel.waterProgress,
                            icon: EntryType.water.icon,
                            color: EntryType.water.color,
                            size: ringSize
                        )
                    }
                }
            }
        }
    }
}
