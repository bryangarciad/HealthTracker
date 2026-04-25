import SwiftUI

struct MainDashboardView: View {
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
                        progress: 0.5,
                        icon: EntryType.water.icon,
                        size: 55
                    )
                    
                    Text("\(Int(1000))")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(EntryType.water.color)
                    
                    Text("\(Int(2000)) ml")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 6) {
                    ProgressRingView(
                        color: EntryType.calories.color,
                        progress: 0.3,
                        icon: EntryType.calories.icon,
                        size: 55
                    )
                    

                    Text("\(Int(300))")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(EntryType.calories.color)
                    

                    Text("\(Int(2000)) kcal")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    MainDashboardView()
}

