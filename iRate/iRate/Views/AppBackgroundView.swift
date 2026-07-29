//
//  AppBackgroundView.swift
//  iRate
//

import SwiftUI

struct AppBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            LinearGradient(
                colors: colorScheme == .dark
                    ? [
                        Color(red: 0.02, green: 0.05, blue: 0.10),
                        Color(red: 0.04, green: 0.09, blue: 0.17),
                        Color(red: 0.03, green: 0.07, blue: 0.13)
                    ]
                    : [
                        Color(red: 0.95, green: 0.98, blue: 1.00),
                        Color(red: 0.89, green: 0.95, blue: 1.00),
                        Color(red: 0.96, green: 0.98, blue: 1.00)
                    ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(AppTheme.accent.opacity(colorScheme == .dark ? 0.16 : 0.12))
                .frame(width: 300, height: 300)
                .blur(radius: 70)
                .offset(x: 170, y: -280)

            Circle()
                .fill(AppTheme.accentDeep.opacity(colorScheme == .dark ? 0.13 : 0.08))
                .frame(width: 260, height: 260)
                .blur(radius: 80)
                .offset(x: -170, y: 300)
        }
        .ignoresSafeArea()
    }
}
