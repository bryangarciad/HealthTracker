import SwiftUI

struct MainDashboardView: View {
    @ObservedObject var viewModel: HealthViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Today")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                
                HStack(spacing: 20) {
                    VStack(spacing: 6) {
                        ProgressRingView(
                            color: .cyan,
                            progress: 0.4,
                            icon: "drop.fill",
                            size: 55
                        )
                        Text("400")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .bold,
                                    design: .rounded
                                )
                            )
                            .foregroundColor(.cyan)
                        Text("2000 ml")
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(spacing: 6) {
                        ProgressRingView(
                            color: .orange,
                            progress: 0.6,
                            icon: "flame.fill",
                            size: 55
                        )
                        Text("600")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .bold,
                                    design: .rounded
                                )
                            )
                            .foregroundColor(.cyan)
                        Text("2000 Kcal")
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                    }
                }
            }
            HStack(spacing: 4) {
                NavigationLink(destination: AddEntryView(viewModel: viewModel, entryType: .water)) {
                    VStack(spacing: 4) {
                        Image(systemName: EntryType.water.icon)
                        font(.system(size: 16, weight: .bold))
                        Text(EntryType.water.displayType)
                            .font(.system(size: 10))
                    }
                    .foregroundColor(EntryType.water.color)
                    .frame(width: 70, height: 50)
                    .background(EntryType.water.color.opacity(0.2))
                    .cornerRadius(12)
                }
                
                NavigationLink(destination: AddEntryView(viewModel: viewModel, entryType: .calories)) {
                    VStack(spacing: 4) {
                        Image(systemName: EntryType.calories.icon)
                        font(.system(size: 16, weight: .bold))
                        Text(EntryType.calories.displayType)
                            .font(.system(size: 10))
                    }
                    .foregroundColor(EntryType.calories.color)
                    .frame(width: 70, height: 50)
                    .background(EntryType.calories.color.opacity(0.2))
                    .cornerRadius(12)
                }
            }
            NavigationLink(destination: GoalSettingsView(viewModel: viewModel)) {
                HStack {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 12))
                    Text("Goals")
                        .font(.system(size: 12))
                }
                .foregroundColor(.gray)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 4)
        }
        .padding(.vertical, 8)
    }
}
