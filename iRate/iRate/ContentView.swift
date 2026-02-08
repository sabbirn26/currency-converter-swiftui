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
    @State private var showSettings = false

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
                        Haptics.selection()
                        activeSheet = .base
                    },
                    onDestinationTap: {
                        focusedInput = false
                        Haptics.selection()
                        activeSheet = .destination
                    },
                    onSwap: {
                        let oldBase = viewModel.baseCr
                        viewModel.baseCr = viewModel.desCrCode
                        viewModel.desCrCode = oldBase
                        Haptics.lightImpact()
                        viewModel.validation()
                    }
                )

                AmountCardView(amountText: $viewModel.baseAmount, isFocused: $focusedInput, onChange: {
                    viewModel.validation()
                })

                ResultCardView(resultText: viewModel.result)

                ConversionsListView(items: viewModel.fullList, onRefresh: {
                    Haptics.lightImpact()
                    await viewModel.refresh()
                })

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 12)
            .animation(.easeOut(duration: 0.5), value: showContent)

            LoadingOverlayView(isLoading: $viewModel.isPayloadCall)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .scrollDismissesKeyboard(.immediately)
        .sheet(item: $activeSheet, onDismiss: {
            searchCr = ""
            hideKeyboard()
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
                    hideKeyboard()
                    Haptics.selection()
                    viewModel.validation()
                }
            )
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onAppear {
            viewModel.validation()
            showContent = true
        }
        .toast(showToast: $viewModel.errorAlert, position: .middle) {
            Text(viewModel.errorMessage)
                .font(.custom("American Typewriter", size: 14))
        }
        .overlay(alignment: .topTrailing) {
            Button(action: {
                hideKeyboard()
                Haptics.lightImpact()
                showSettings = true
            }) {
                CircleButtonView(iconName: "gearshape")
            }
            .padding(.trailing, 6)
            .padding(.top, 6)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedInput = false
                    hideKeyboard()
                }
                .font(.custom("American Typewriter", size: 14))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
