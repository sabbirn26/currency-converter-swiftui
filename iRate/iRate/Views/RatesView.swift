//
//  RatesView.swift
//  iRate
//

import SwiftUI

struct RatesView: View {
    @ObservedObject var viewModel: CurrencyViewModel
    let onSelectCurrency: (String) -> Void

    @State private var searchText = ""
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    var body: some View {
        ZStack {
            VStack(spacing: 18) {
                TabPageHeader(
                    title: L10n.t("Exchange rates", language: appLanguage),
                    subtitle: L10n.t("Browse and choose any currency.", language: appLanguage),
                    icon: "chart.line.uptrend.xyaxis"
                )

                searchField

                if viewModel.hasError {
                    RateErrorCard {
                        retry()
                    }
                }

                if !filteredRows.isEmpty {
                    ConversionsListView(
                        title: L10n.t("All currencies", language: appLanguage),
                        items: filteredRows,
                        onSelect: selectCurrency,
                        onFavorite: toggleFavorite,
                        onRefresh: refresh
                    )
                } else {
                    if !viewModel.rates.isEmpty {
                        EmptyStateCard(
                            icon: "magnifyingglass",
                            title: L10n.t("No currencies found", language: appLanguage),
                            message: L10n.t("Try a different currency code.", language: appLanguage)
                        )
                    }

                    Spacer(minLength: 0)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 12)

            LoadingOverlayView(isLoading: viewModel.isInitialLoading)
        }
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppTheme.secondaryText)

            TextField(
                L10n.t("Search currency", language: appLanguage),
                text: $searchText
            )
            .textInputAutocapitalization(.characters)
            .autocorrectionDisabled()
            .foregroundStyle(AppTheme.primaryText)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(AppTheme.secondaryText)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(AppTheme.elevatedBackground, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 17, style: .continuous)
                .stroke(AppTheme.border, lineWidth: 1)
        }
    }

    private var filteredRows: [CurrencyRateRow] {
        guard !searchText.isEmpty else { return viewModel.currencyRows }
        return viewModel.currencyRows.filter {
            $0.code.localizedCaseInsensitiveContains(searchText)
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
