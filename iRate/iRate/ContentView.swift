//
//  ContentView.swift
//  iRate
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CurrencyViewModel()
    @State private var selectedTab: AppTab = .convert

    var body: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: 0) {
                ZStack {
                    ConverterView(
                        viewModel: viewModel,
                        onOpenSettings: {
                            selectTab(.settings)
                        }
                    )
                    .appTabContent(isSelected: selectedTab == .convert)

                    RatesView(
                        viewModel: viewModel,
                        onSelectCurrency: { code in
                            viewModel.selectDestination(code)
                            selectTab(.convert)
                        }
                    )
                    .appTabContent(isSelected: selectedTab == .rates)

                    FavoritesView(
                        viewModel: viewModel,
                        onSelectCurrency: { code in
                            viewModel.selectDestination(code)
                            selectTab(.convert)
                        }
                    )
                    .appTabContent(isSelected: selectedTab == .favorites)

                    SettingsView(showsCloseButton: false)
                        .appTabContent(isSelected: selectedTab == .settings)
                }

                AppTabBar(selection: $selectedTab)
            }
        }
        .onChange(of: selectedTab) { _ in
            Haptics.selection()
        }
        .task {
            let shouldConfirmLoad = viewModel.rates.isEmpty
            await viewModel.loadInitial()
            if shouldConfirmLoad {
                viewModel.hasError ? Haptics.error() : Haptics.success()
            }
        }
    }

    private func selectTab(_ tab: AppTab) {
        selectedTab = tab
    }
}

private extension View {
    func appTabContent(isSelected: Bool) -> some View {
        opacity(isSelected ? 1 : 0)
            .allowsHitTesting(isSelected)
            .accessibilityHidden(!isSelected)
    }
}

#Preview {
    ContentView()
}
