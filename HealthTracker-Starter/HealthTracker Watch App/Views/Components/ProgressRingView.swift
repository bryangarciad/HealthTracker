//
//  ProgressRingView.swift
//  HealthTracker Watch App
//
//  ┌───────────────────────────────────────────────────────────────────────┐
//  │  A REUSABLE COMPONENT.                                                  │
//  │                                                                         │
//  │  This is one of those Apple-Watch-style rings that fill up as you make  │
//  │  progress. We build it ONCE here and reuse it for BOTH calories and     │
//  │  water — just by passing in a different color, icon and progress value. │
//  │                                                                         │
//  │  A ring is really two circles stacked on top of each other:            │
//  │    • a faint FULL circle in the background (the "track"), and           │
//  │    • a brighter circle on top that is only partly drawn — the amount    │
//  │      drawn equals `progress`.                                           │
//  └───────────────────────────────────────────────────────────────────────┘
//

import SwiftUI

struct ProgressRingView: View {
    let progress: Double   // 0.0 (empty) ... 1.0 (full)
    let icon: String       // an SF Symbol name, e.g. "flame.fill"
    let color: Color
    let size: CGFloat

    private let lineWidth: CGFloat = 8

    var body: some View {
        ZStack {   // ZStack layers views on top of each other

            // LAYER 1 — the faint background track (this part is done for you).
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)

            // ╔═══════════════════════════════════════════════════════════════╗
            // ║  ✏️  EXERCISE 1 — Draw the progress arc                       ║
            // ║                                                               ║
            // ║  Add a SECOND Circle here, on top of the track, that is only  ║
            // ║  drawn from 0 up to `progress`. Starter snippet:              ║
            // ║                                                               ║
            // ║      Circle()                                                 ║
            // ║          .trim(from: 0, to: progress)                         ║
            // ║          .stroke(                                             ║
            // ║              color,                                           ║
            // ║              style: StrokeStyle(lineWidth: lineWidth,         ║
            // ║                                 lineCap: .round)              ║
            // ║          )                                                    ║
            // ║          .rotationEffect(.degrees(-90))                       ║
            // ║          .animation(.easeInOut, value: progress)              ║
            // ║                                                               ║
            // ║  What each piece does:                                        ║
            // ║   • .trim(from:to:) draws only PART of the circle. to: 0.25   ║
            // ║     draws a quarter, 1.0 draws the whole thing.               ║
            // ║   • .rotationEffect(-90) rotates it so the ring starts        ║
            // ║     filling from the TOP instead of the right side.           ║
            // ║   • .animation(...) makes the fill grow smoothly.             ║
            // ║                                                               ║
            // ║  Paste the snippet right below this comment block.            ║
            // ╚═══════════════════════════════════════════════════════════════╝


            // LAYER 3 — the icon in the middle (done for you).
            Image(systemName: icon)
                .font(.system(size: size * 0.3))
                .foregroundColor(color)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    HStack(spacing: 16) {
        ProgressRingView(progress: 0.3, icon: "flame.fill", color: .orange, size: 60)
        ProgressRingView(progress: 0.6, icon: "drop.fill", color: .cyan, size: 60)
    }
}
