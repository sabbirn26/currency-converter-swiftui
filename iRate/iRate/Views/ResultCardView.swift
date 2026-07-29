//
//  ResultCardView.swift
//  iRate
//

import SwiftUI

struct ResultCardView: View {
    let resultText: String
    let rateText: String
    let updatedText: String?
    let hasValidAmount: Bool
    @State private var bump = false
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(
                    L10n.t("Converted", language: appLanguage),
                    systemImage: "sparkles"
                )
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.82))

                Spacer()

                if let updatedText {
                    Text(L10n.format("Updated %@", language: appLanguage, updatedText))
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.white.opacity(0.68))
                }
            }

            Text(hasValidAmount ? (resultText.isEmpty ? "—" : resultText) : L10n.t("Enter a valid amount", language: appLanguage))
                .font(.system(size: hasValidAmount ? 31 : 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
                .scaleEffect(bump ? 1.025 : 1)

            if !rateText.isEmpty {
                Text(rateText)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.78))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(AppTheme.accentGradient, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.18), lineWidth: 1)
        }
        .shadow(color: AppTheme.accentDeep.opacity(0.28), radius: 18, y: 10)
        .onChange(of: resultText) { _ in
            withAnimation(.spring(response: 0.25, dampingFraction: 0.62)) {
                bump = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.62)) {
                    bump = false
                }
            }
        }
    }
}
