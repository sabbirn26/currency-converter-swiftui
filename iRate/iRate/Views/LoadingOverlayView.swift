//
//  LoadingOverlayView.swift
//  iRate
//

import SwiftUI

struct LoadingOverlayView: View {
    let isLoading: Bool
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    var body: some View {
        if isLoading {
            ZStack {
                AppTheme.background.opacity(0.78)
                    .ignoresSafeArea()

                VStack(spacing: 14) {
                    ProgressView()
                        .controlSize(.large)
                        .tint(AppTheme.accent)

                    Text(L10n.t("Updating rates", language: appLanguage))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.primaryText)
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 22)
                .appCard(cornerRadius: 22)
            }
            .transition(.opacity)
            .zIndex(10)
        }
    }
}
