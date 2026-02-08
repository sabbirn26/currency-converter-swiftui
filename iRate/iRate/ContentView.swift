//
//  ContentView.swift
//  iRate
//
//  Created by Sabbir Nasir on 8/2/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CurrencyViewModel()
    @FocusState private var focusedInput: Bool
    @State private var searchCr = ""
    @State private var activeSheet: PickerTarget?
    @State private var showContent = false

    enum PickerTarget: Identifiable {
        case base
        case destination

        var id: Int { self == .base ? 0 : 1 }
    }

    var body: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: 20) {
                HeaderView()

                CurrencySelectorView(
                    baseCode: viewModel.baseCr,
                    destinationCode: viewModel.desCrCode,
                    onBaseTap: {
                        focusedInput = false
                        activeSheet = .base
                    },
                    onDestinationTap: {
                        focusedInput = false
                        activeSheet = .destination
                    },
                    onSwap: {
                        let oldBase = viewModel.baseCr
                        viewModel.baseCr = viewModel.desCrCode
                        viewModel.desCrCode = oldBase
                        viewModel.validation()
                    }
                )

                AmountCardView(amountText: $viewModel.baseAmount, isFocused: $focusedInput, onChange: {
                    viewModel.validation()
                })

                ResultCardView(resultText: viewModel.result)

                ConversionsListView(items: viewModel.fullList, onRefresh: {
                    await viewModel.refresh()
                })
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 12)
            .animation(.easeOut(duration: 0.5), value: showContent)

            LoadingOverlayView(isLoading: $viewModel.isPayloadCall)
        }
        .sheet(item: $activeSheet, onDismiss: {
            searchCr = ""
        }) { target in
            CurrencyPickerSheet(
                title: target == .base ? "Your currency" : "To currency",
                searchText: $searchCr,
                codes: viewModel.onlyCrCodes,
                onSelect: { code in
                    if target == .base {
                        viewModel.baseCr = code
                    } else {
                        viewModel.desCrCode = code
                    }
                    searchCr = ""
                    activeSheet = nil
                    viewModel.validation()
                }
            )
            .presentationDetents([.medium, .large])
        }
        .onAppear {
            viewModel.validation()
            showContent = true
        }
        .toast(showToast: $viewModel.errorAlert, position: .middle) {
            Text(viewModel.errorMessage)
                .font(.custom("American Typewriter", size: 14))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
