//
//  QuickAddButton.swift
//  HealthTracker Watch App
//
//  A small reusable "card" used for the Calories / Water buttons on the
//  dashboard. It is just a label — the TAP behaviour is handled by the
//  NavigationLink that wraps it on the dashboard. (Done for you; read it to
//  see how a tiny reusable view is built.)
//

import SwiftUI

struct QuickAddButton: View {
    let icon: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
            Text(label)
                .font(.system(size: 10))
        }
        .foregroundColor(color)
        .frame(width: 70, height: 50)
        .background(color.opacity(0.3))
        .cornerRadius(12)
    }
}

#Preview {
    QuickAddButton(icon: "drop.fill", label: "Water", color: .cyan)
}
