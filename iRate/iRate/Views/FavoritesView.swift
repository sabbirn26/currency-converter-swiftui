//
//  FavoritesView.swift
//  iRate
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: CurrencyViewModel
    let onSelectCurrency: (String) -> Void
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    var body: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: 18) {
                TabPageHeader(
                    title: L10n.t("Favorite currencies", language: appLanguage),
                    subtitle: L10n.t("Your saved currencies in one place.", language: appLanguage),
                    icon: "star.fill"
                )

                if viewModel.hasError {
                    RateErrorCard {
                        retry()
                    }
                }

                if viewModel.favoriteRows.isEmpty {
                    EmptyStateCard(
                        icon: "star",
                        title: L10n.t("No favorites yet", language: appLanguage),
                        message: L10n.t("Add favorites from the Rates tab.", language: appLanguage)
                    )

                    Spacer(minLength: 0)
                } else {
                    ConversionsListView(
                        title: L10n.t("Favorites", language: appLanguage),
                        items: viewModel.favoriteRows,
                        onSelect: selectCurrency,
                        onFavorite: toggleFavorite,
                        onRefresh: refresh
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 12)

            LoadingOverlayView(isLoading: viewModel.isInitialLoading)
        }
    }

    private func selectCurrency(_ code: String) {
        onSelectCurrency(code)
    }

    private func toggleFavorite(_ code: String) {
        Haptics.selection()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            viewModel.toggleFavorite(code)
        }
    }

    private func refresh() async {
        Haptics.lightImpact()
        await viewModel.refresh()
        viewModel.hasError ? Haptics.error() : Haptics.success()
    }

    private func retry() {
        Haptics.lightImpact()
        Task {
            await viewModel.retry()
            viewModel.hasError ? Haptics.error() : Haptics.success()
        }
    }
}
