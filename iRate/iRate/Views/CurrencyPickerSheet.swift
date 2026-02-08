//
//  CurrencyPickerSheet.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import SwiftUI

struct CurrencyPickerSheet: View {
    let title: String
    @Binding var searchText: String
    let codes: [String]
    let onSelect: (String) -> Void
    @AppStorage("appLanguage") private var appLanguage = "en"

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.09, green: 0.12, blue: 0.20),
                    Color(red: 0.12, green: 0.18, blue: 0.28)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 14) {
                Text(L10n.t(title, language: appLanguage))
                    .font(.custom("American Typewriter", size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 12)

                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.7))
                    TextField(L10n.t("Search currency", language: appLanguage), text: $searchText)
                        .textInputAutocapitalization(.characters)
                        .foregroundColor(.white)
                }
                .padding(12)
                .background(Color.white.opacity(0.12))
                .cornerRadius(12)
                .padding(.horizontal, 16)

                List {
                    ForEach(filteredCodes, id: \.self) { code in
                        Button(action: { onSelect(code) }) {
                            HStack(spacing: 10) {
                                Text(CurrencyFlag.emoji(for: code))
                                    .font(.system(size: 18))

                                Text(code)
                                    .font(.custom("American Typewriter", size: 16))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.vertical, 6)
                        }
                        .listRowBackground(Color.white.opacity(0.06))
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
        }
    }

    private var filteredCodes: [String] {
        if searchText.isEmpty {
            return codes
        }
        return codes.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
}
