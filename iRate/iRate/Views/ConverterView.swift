//
//  ConverterView.swift
//  iRate
//

import SwiftUI

struct ConverterView: View {
    @ObservedObject var viewModel: CurrencyViewModel
    let onOpenSettings: () -> Void

    @FocusState private var focusedInput: Bool
    @State private var searchCurrency = ""
    @State private var activeSheet: PickerTarget?
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

            VStack(spacing: 12) {
                HeaderView(onSettings: onOpenSettings)
                converterCard

                if viewModel.hasError {
                    RateErrorCard {
                        retry()
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 10)
            .animation(.easeOut(duration: 0.4), value: showContent)

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
        VStack(spacing: 14) {
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
        .padding(14)
        .appCard(cornerRadius: 24)
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

    private func retry() {
        Haptics.lightImpact()
        Task {
            await viewModel.retry()
            viewModel.hasError ? Haptics.error() : Haptics.success()
        }
    }
}
