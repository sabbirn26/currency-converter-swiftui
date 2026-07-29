//
//  ContentView.swift
//  iRate
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CurrencyViewModel()
    @State private var selectedTab: AppTab = .convert
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    var body: some View {
        TabView(selection: $selectedTab) {
            ConverterView(
                viewModel: viewModel,
                onOpenSettings: {
                    selectTab(.settings)
                }
            )
            .tag(AppTab.convert)
            .tabItem {
                Label(
                    L10n.t("Convert", language: appLanguage),
                    systemImage: "arrow.left.arrow.right"
                )
            }

            RatesView(
                viewModel: viewModel,
                onSelectCurrency: { code in
                    viewModel.selectDestination(code)
                    selectTab(.convert)
                }
            )
            .tag(AppTab.rates)
            .tabItem {
                Label(
                    L10n.t("Rates", language: appLanguage),
                    systemImage: "list.bullet"
                )
            }

            FavoritesView(
                viewModel: viewModel,
                onSelectCurrency: { code in
                    viewModel.selectDestination(code)
                    selectTab(.convert)
                }
            )
            .tag(AppTab.favorites)
            .tabItem {
                Label(
                    L10n.t("Favorites", language: appLanguage),
                    systemImage: "star"
                )
            }

            SettingsView(showsCloseButton: false)
                .tag(AppTab.settings)
                .tabItem {
                    Label(
                        L10n.t("Settings", language: appLanguage),
                        systemImage: "gearshape"
                    )
                }
        }
        .tint(AppTheme.accentDeep)
        .toolbarBackground(AppTheme.elevatedBackground, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
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

private enum AppTab: Hashable {
    case convert
    case rates
    case favorites
    case settings
}

#Preview {
    ContentView()
}
