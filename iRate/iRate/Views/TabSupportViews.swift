//
//  TabSupportViews.swift
//  iRate
//

import SwiftUI

enum AppTab: CaseIterable, Hashable {
    case convert
    case rates
    case favorites
    case settings

    var titleKey: String {
        switch self {
        case .convert: return "Convert"
        case .rates: return "Rates"
        case .favorites: return "Favorites"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .convert: return "arrow.left.arrow.right"
        case .rates: return "list.bullet"
        case .favorites: return "star"
        case .settings: return "gearshape"
        }
    }
}

struct AppTabBar: View {
    @Binding var selection: AppTab
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button {
                    selection = tab
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 18, weight: .semibold))

                        Text(L10n.t(tab.titleKey, language: appLanguage))
                            .font(.caption2.weight(.semibold))
                            .lineLimit(1)
                    }
                    .foregroundStyle(selection == tab ? AppTheme.accentDeep : AppTheme.secondaryText)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selection == tab ? .isSelected : [])
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 64)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppTheme.elevatedBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                }
                .shadow(color: AppTheme.shadow, radius: 14, y: 6)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 6)
    }
}

struct TabPageHeader: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(AppTheme.accentGradient, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                .shadow(color: AppTheme.accent.opacity(0.3), radius: 10, y: 5)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer()
        }
    }
}

struct RateErrorCard: View {
    let onRetry: () -> Void
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(AppTheme.danger)
                .frame(width: 44, height: 44)
                .background(AppTheme.danger.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.t("Unable to update rates", language: appLanguage))
                    .font(.headline)
                    .foregroundStyle(AppTheme.primaryText)
                Text(L10n.t("Pull to refresh or try again.", language: appLanguage))
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer(minLength: 8)

            Button(L10n.t("Retry", language: appLanguage), action: onRetry)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.accentDeep)
        }
        .padding(16)
        .appCard(cornerRadius: 20)
    }
}

struct EmptyStateCard: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(AppTheme.accentDeep)
                .frame(width: 52, height: 52)
                .background(AppTheme.accent.opacity(0.12), in: Circle())

            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.primaryText)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
        .appCard(cornerRadius: 24)
    }
}
