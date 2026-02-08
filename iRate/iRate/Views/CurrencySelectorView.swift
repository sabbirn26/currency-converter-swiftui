//
//  CurrencySelectorView.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import SwiftUI

struct CurrencySelectorView: View {
    let baseCode: String
    let destinationCode: String
    let onBaseTap: () -> Void
    let onDestinationTap: () -> Void
    let onSwap: () -> Void
    @State private var swapRotation: Double = 0

    var body: some View {
        HStack(spacing: 14) {
            CurrencyCardView(
                title: "From",
                code: baseCode,
                accent: Color(red: 0.40, green: 0.78, blue: 0.95),
                onTap: onBaseTap
            )

            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                    swapRotation += 180
                }
                onSwap()
            }) {
                swapIcon
            }
            .buttonStyle(.plain)

            CurrencyCardView(
                title: "To",
                code: destinationCode,
                accent: Color(red: 0.98, green: 0.61, blue: 0.38),
                onTap: onDestinationTap
            )
        }
    }

    private var swapIcon: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 38, height: 38)

            Image(systemName: "arrow.left.arrow.right")
                .foregroundColor(.white.opacity(0.9))
                .font(.system(size: 14, weight: .semibold))
                .rotationEffect(.degrees(swapRotation))
        }
        .padding(.top, 12)
    }
}
