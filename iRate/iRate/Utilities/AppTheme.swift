//
//  AppTheme.swift
//  iRate
//

import SwiftUI
import UIKit

enum AppStorageKeys {
    static let appLanguage = "appLanguage"
    static let appTheme = "appTheme"
    static let hapticsEnabled = "hapticsEnabled"
    static let favoriteCurrencies = "favoriteCurrencies"
}

enum AppThemeMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    var localizationKey: String {
        rawValue.capitalized
    }
}

enum AppTheme {
    static let accent = Color(red: 0.08, green: 0.72, blue: 0.94)
    static let accentDeep = Color(red: 0.12, green: 0.38, blue: 0.96)
    static let success = Color(red: 0.16, green: 0.76, blue: 0.57)
    static let warning = Color(red: 0.98, green: 0.58, blue: 0.26)
    static let danger = Color(red: 0.96, green: 0.31, blue: 0.39)

    static let background = dynamicColor(
        light: UIColor(red: 0.94, green: 0.97, blue: 1.00, alpha: 1),
        dark: UIColor(red: 0.025, green: 0.055, blue: 0.11, alpha: 1)
    )
    static let elevatedBackground = dynamicColor(
        light: UIColor(red: 0.98, green: 0.99, blue: 1.00, alpha: 0.96),
        dark: UIColor(red: 0.055, green: 0.10, blue: 0.18, alpha: 0.96)
    )
    static let secondaryBackground = dynamicColor(
        light: UIColor(red: 0.89, green: 0.94, blue: 0.99, alpha: 1),
        dark: UIColor(red: 0.075, green: 0.13, blue: 0.22, alpha: 1)
    )
    static let primaryText = dynamicColor(
        light: UIColor(red: 0.04, green: 0.10, blue: 0.18, alpha: 1),
        dark: UIColor(red: 0.94, green: 0.98, blue: 1.00, alpha: 1)
    )
    static let secondaryText = dynamicColor(
        light: UIColor(red: 0.30, green: 0.39, blue: 0.50, alpha: 1),
        dark: UIColor(red: 0.62, green: 0.72, blue: 0.83, alpha: 1)
    )
    static let border = dynamicColor(
        light: UIColor(red: 0.76, green: 0.85, blue: 0.94, alpha: 0.72),
        dark: UIColor(red: 0.22, green: 0.38, blue: 0.54, alpha: 0.55)
    )
    static let shadow = Color.black.opacity(0.16)

    static let accentGradient = LinearGradient(
        colors: [accent, accentDeep],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func card(cornerRadius: CGFloat = 24) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(elevatedBackground)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(border, lineWidth: 1)
            }
            .shadow(color: shadow, radius: 22, x: 0, y: 12)
    }

    private static func dynamicColor(light: UIColor, dark: UIColor) -> Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        })
    }
}

extension View {
    func appCard(cornerRadius: CGFloat = 24) -> some View {
        background(AppTheme.card(cornerRadius: cornerRadius))
    }
}
