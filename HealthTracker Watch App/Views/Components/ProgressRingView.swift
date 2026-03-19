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
            
            // Overlap Progress Circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            
            // Icon In The Center
            Image(systemName: icon)
                .font(.system(size: size * 0.4))
                .foregroundColor(color)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    HStack {
        ProgressRingView(
            color: .cyan,
            progress: 0.5,
            icon: "drop.fill",
            size: 60
        )
        
        ProgressRingView(
            color: .orange,
            progress: 0.5,
            icon: "flame.fill",
            size: 60
        )
    }
}
