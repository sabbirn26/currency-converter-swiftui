//
//  AmountCardView.swift
//  iRate
//

import SwiftUI

struct AmountCardView: View {
    @Binding var amountText: String
    @FocusState.Binding var isFocused: Bool
    let onQuickAmount: (Double) -> Void
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    private let quickAmounts: [Double] = [1, 10, 100, 1000]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L10n.t("Amount", language: appLanguage))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.primaryText)

            HStack(spacing: 12) {
                TextField(
                    L10n.t("Enter an amount", language: appLanguage),
                    text: $amountText
                )
                .keyboardType(.decimalPad)
                .focused($isFocused)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.primaryText)

                Image(systemName: "number")
                    .font(.headline)
                    .foregroundStyle(AppTheme.accent)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(AppTheme.secondaryBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isFocused ? AppTheme.accent : AppTheme.border, lineWidth: isFocused ? 1.5 : 1)
            }
            .animation(.easeInOut(duration: 0.18), value: isFocused)

            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.t("Quick amounts", language: appLanguage))
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.secondaryText)

                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 64), spacing: 8)],
                    spacing: 8
                ) {
                    ForEach(quickAmounts, id: \.self) { amount in
                        Button {
                            onQuickAmount(amount)
                        } label: {
                            Text(String(format: "%.0f", amount))
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(
                                    amountText == String(format: "%.0f", amount)
                                        ? Color.white
                                        : AppTheme.primaryText
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 7)
                                .background {
                                    Capsule()
                                        .fill(
                                            amountText == String(format: "%.0f", amount)
                                                ? AnyShapeStyle(AppTheme.accentGradient)
                                                : AnyShapeStyle(AppTheme.secondaryBackground)
                                        )
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
