//
//  CurrencyCardView.swift
//  iRate
//

import SwiftUI

struct CurrencyCardView: View {
    let title: String
    let code: String
    let accent: Color
    let onTap: () -> Void
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 7) {
                Text(L10n.t(title, language: appLanguage))
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.secondaryText)

                HStack(spacing: 8) {
                    Text(CurrencyFlag.emoji(for: code))
                        .font(.system(size: 20))

                    Text(code)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.primaryText)

                    Spacer(minLength: 0)

                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.secondaryText)
                }

                Capsule()
                    .fill(accent)
                    .frame(width: 32, height: 4)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.secondaryBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(L10n.t(title, language: appLanguage)), \(code)")
    }
}
