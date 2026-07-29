//
//  HeaderView.swift
//  iRate
//

import SwiftUI

struct HeaderView: View {
    let onSettings: () -> Void
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(AppTheme.accentGradient)
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 48, height: 48)
            .shadow(color: AppTheme.accent.opacity(0.35), radius: 12, y: 6)

            VStack(alignment: .leading, spacing: 3) {
                Text("iRate")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText)

                Text(L10n.t("Live exchange rates", language: appLanguage))
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer()

            Button(action: onSettings) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)
                    .frame(width: 44, height: 44)
                    .background(AppTheme.elevatedBackground, in: Circle())
                    .overlay {
                        Circle().stroke(AppTheme.border, lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(L10n.t("Settings", language: appLanguage))
        }
    }
}
