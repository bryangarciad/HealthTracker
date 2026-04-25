import SwiftUI

struct ProgressRingView: View {
    let color: Color
    let progress: Double
    let icon: String
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 8)
            
            // Overlap Progress Circle (trimmed circle)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 5), value: progress)
            
            Image(systemName: icon)
                .font(.system(size: size * 0.4))
                .foregroundColor(color)
        }
        .frame(width: size, height: size)
    }
}


// ProgressRingView(color: .cyan, progress: 0.5, icon: "flame.fill", size: 50)
// ProgressRingView(color: .orange, progress: 0.3, icon: "flame.fill", size: 50)

#Preview {
    HStack(spacing: 16) {
        ProgressRingView(
            color: .cyan,
            progress: 0.1,
            icon: "drop.fill",
            size: 90
        )
        
        ProgressRingView(
            color: .orange,
            progress: 0.8,
            icon: "flame.fill",
            size: 90
        )
    }
}
