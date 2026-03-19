import SwiftUI

struct MainDashboardView: View {
    
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
        }
    }
}

#Preview {
    MainDashboardView()
}
