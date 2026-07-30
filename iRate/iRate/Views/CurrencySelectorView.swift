//
//  CurrencySelectorView.swift
//  iRate
//

import SwiftUI

struct CurrencySelectorView: View {
    let baseCode: String
    let destinationCode: String
    let isRefreshing: Bool
    let onBaseTap: () -> Void
    let onDestinationTap: () -> Void
    let onSwap: () -> Void
    @State private var swapRotation: Double = 0
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    var body: some View {
        ViewThatFits(in: .horizontal) {
            horizontalLayout
            verticalLayout
        }
    }

    private var horizontalLayout: some View {
        HStack(spacing: 8) {
            CurrencyCardView(
                title: "From",
                code: baseCode,
                accent: AppTheme.accent,
                onTap: onBaseTap
            )
            .frame(minWidth: 120)

            swapButton

            CurrencyCardView(
                title: "To",
                code: destinationCode,
                accent: AppTheme.warning,
                onTap: onDestinationTap
            )
            .frame(minWidth: 120)
        }
    }

    private var verticalLayout: some View {
        VStack(spacing: 10) {
            CurrencyCardView(
                title: "From",
                code: baseCode,
                accent: AppTheme.accent,
                onTap: onBaseTap
            )

            swapButton

            CurrencyCardView(
                title: "To",
                code: destinationCode,
                accent: AppTheme.warning,
                onTap: onDestinationTap
            )
        }
    }

    private var swapButton: some View {
        Button {
            withAnimation(.spring(response: 0.38, dampingFraction: 0.65)) {
                swapRotation += 180
            }
            onSwap()
        } label: {
            ZStack {
                Circle()
                    .fill(AppTheme.accentGradient)
                    .frame(width: 40, height: 40)
                    .shadow(color: AppTheme.accent.opacity(0.32), radius: 10, y: 5)

                if isRefreshing {
                    ProgressView()
                        .controlSize(.small)
                        .tint(.white)
                } else {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(swapRotation))
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(L10n.t("Swap currencies", language: appLanguage))
    }
}
