//
//  ContentView.swift
//  iRate
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CurrencyViewModel()
    @FocusState private var focusedInput: Bool
    @State private var searchCurrency = ""
    @State private var activeSheet: PickerTarget?
    @State private var showSettings = false
    @State private var showContent = false
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    enum PickerTarget: Identifiable {
        case base
        case destination

        var id: Int { self == .base ? 0 : 1 }
    }

    var body: some View {
        ZStack {
            AppBackgroundView()

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 18) {
                    HeaderView {
                        focusedInput = false
                        Haptics.lightImpact()
                        showSettings = true
                    }

                    converterCard

                    if viewModel.hasError {
                        errorCard
                    }

                    if !viewModel.rates.isEmpty {
                        if viewModel.favoriteRows.isEmpty {
                            favoritesEmptyCard
                        } else {
                            ConversionsListView(
                                title: L10n.t("Favorites", language: appLanguage),
                                items: viewModel.favoriteRows,
                                onSelect: selectDestination,
                                onFavorite: toggleFavorite
                            )
                        }
                    }

                    if !viewModel.allRows.isEmpty {
                        ConversionsListView(
                            title: L10n.t("All currencies", language: appLanguage),
                            items: viewModel.allRows,
                            onSelect: selectDestination,
                            onFavorite: toggleFavorite
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 36)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 10)
                .animation(.easeOut(duration: 0.45), value: showContent)
            }
            .refreshable {
                Haptics.lightImpact()
                await viewModel.refresh()
                viewModel.hasError ? Haptics.error() : Haptics.success()
            }
            .scrollDismissesKeyboard(.immediately)

            LoadingOverlayView(isLoading: viewModel.isInitialLoading)
        }
        .onTapGesture {
            focusedInput = false
            hideKeyboard()
        }
        .sheet(item: $activeSheet, onDismiss: {
            searchCurrency = ""
            hideKeyboard()
        }) { target in
            CurrencyPickerSheet(
                title: target == .base ? "Your currency" : "To currency",
                searchText: $searchCurrency,
                codes: viewModel.onlyCrCodes,
                selectedCode: target == .base ? viewModel.baseCr : viewModel.desCrCode,
                favoriteCodes: viewModel.favoriteCodes,
                onSelect: { code in
                    selectCurrency(code, for: target)
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .task {
            let shouldConfirmLoad = viewModel.rates.isEmpty
            await viewModel.loadInitial()
            if shouldConfirmLoad {
                viewModel.hasError ? Haptics.error() : Haptics.success()
            }
        }
        .onAppear {
            showContent = true
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(L10n.t("Done", language: appLanguage)) {
                    focusedInput = false
                    hideKeyboard()
                }
                .foregroundStyle(AppTheme.accentDeep)
            }
        }
    }

    private var converterCard: some View {
        VStack(spacing: 18) {
            CurrencySelectorView(
                baseCode: viewModel.baseCr,
                destinationCode: viewModel.desCrCode,
                isRefreshing: viewModel.isRefreshing,
                onBaseTap: {
                    focusedInput = false
                    Haptics.selection()
                    activeSheet = .base
                },
                onDestinationTap: {
                    focusedInput = false
                    Haptics.selection()
                    activeSheet = .destination
                },
                onSwap: {
                    focusedInput = false
                    Haptics.lightImpact()
                    Task {
                        await viewModel.swapCurrencies()
                        viewModel.hasError ? Haptics.error() : Haptics.success()
                    }
                }
            )

            Divider()
                .overlay(AppTheme.border)

            AmountCardView(
                amountText: Binding(
                    get: { viewModel.baseAmount },
                    set: { viewModel.updateAmount($0) }
                ),
                isFocused: $focusedInput,
                onQuickAmount: { amount in
                    Haptics.selection()
                    viewModel.selectQuickAmount(amount)
                }
            )

            ResultCardView(
                resultText: viewModel.result,
                rateText: viewModel.exchangeRateText,
                updatedText: viewModel.lastUpdatedText(language: appLanguage),
                hasValidAmount: viewModel.hasValidAmount
            )
        }
        .padding(18)
        .appCard(cornerRadius: 28)
    }

    private var errorCard: some View {
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

            Button(L10n.t("Retry", language: appLanguage)) {
                Haptics.lightImpact()
                Task {
                    await viewModel.retry()
                    viewModel.hasError ? Haptics.error() : Haptics.success()
                }
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(AppTheme.accentDeep)
        }
        .padding(16)
        .appCard(cornerRadius: 20)
    }

    private var favoritesEmptyCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "star")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppTheme.warning)
                .frame(width: 42, height: 42)
                .background(AppTheme.warning.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(L10n.t("No favorites yet", language: appLanguage))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.primaryText)
                Text(L10n.t("Star a currency to keep it close.", language: appLanguage))
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer()
        }
        .padding(16)
        .appCard(cornerRadius: 20)
    }

    private func selectCurrency(_ code: String, for target: PickerTarget) {
        activeSheet = nil
        searchCurrency = ""
        Haptics.selection()

        switch target {
        case .base:
            Task {
                await viewModel.selectBase(code)
                viewModel.hasError ? Haptics.error() : Haptics.success()
            }
        case .destination:
            viewModel.selectDestination(code)
        }
    }

    private func selectDestination(_ code: String) {
        Haptics.selection()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.78)) {
            viewModel.selectDestination(code)
        }
    }

    private func toggleFavorite(_ code: String) {
        Haptics.selection()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            viewModel.toggleFavorite(code)
        }
    }
}

#Preview {
    ContentView()
}
