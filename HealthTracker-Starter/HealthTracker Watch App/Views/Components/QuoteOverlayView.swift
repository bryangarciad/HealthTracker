//
//  QuoteOverlayView.swift
//  HealthTracker Watch App
//
//  The little full-screen card that pops up with a motivational quote after
//  the user logs something. Shows a spinner while loading, then the quote.
//  (Done for you — read it to see how an overlay and a tap-to-dismiss work.)
//

import SwiftUI

struct QuoteOverlayView: View {
    let quote: MotivationalQuote?
    let isLoading: Bool
    let onDismiss: () -> Void   // a closure the parent passes in to hide us

    var body: some View {
        ZStack {
            // Dim the screen behind the card.
            Color.black.opacity(0.9)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                if isLoading {
                    ProgressView()           // a spinner
                        .tint(.white)
                } else if let quote = quote {
                    Image(systemName: "quote.opening")
                        .font(.title3)
                        .foregroundColor(.yellow)

                    Text(quote.quote)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)

                    Text("— \(quote.author)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray)
                }

                Text("Tap to dismiss")
                    .font(.system(size: 9))
                    .foregroundColor(.gray.opacity(0.7))
                    .padding(.top, 8)
            }
            .padding(.horizontal, 12)
        }
        .onTapGesture { onDismiss() }
    }
}
