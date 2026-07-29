//
//  CurrencyPickerSheet.swift
//  iRate
//

import SwiftUI

struct CurrencyPickerSheet: View {
    let title: String
    @Binding var searchText: String
    let codes: [String]
    let selectedCode: String
    let favoriteCodes: Set<String>
    let onSelect: (String) -> Void
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    var body: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: 16) {
                VStack(spacing: 5) {
                    Text(L10n.t(title, language: appLanguage))
                        .font(.title3.weight(.bold))
                        .foregroundStyle(AppTheme.primaryText)

                    Text(L10n.t("Choose a currency", language: appLanguage))
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                }
                .padding(.top, 12)

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
                .padding(.vertical, 12)
                .background(AppTheme.elevatedBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                }
                .padding(.horizontal, 20)

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 9) {
                        ForEach(filteredCodes, id: \.self) { code in
                            Button {
                                onSelect(code)
                            } label: {
                                HStack(spacing: 12) {
                                    Text(CurrencyFlag.emoji(for: code))
                                        .font(.system(size: 23))

                                    Text(code)
                                        .font(.system(.body, design: .rounded, weight: .semibold))
                                        .foregroundStyle(AppTheme.primaryText)

                                    if favoriteCodes.contains(code) {
                                        Image(systemName: "star.fill")
                                            .font(.caption)
                                            .foregroundStyle(AppTheme.warning)
                                    }

                                    Spacer()

                                    if code == selectedCode {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(AppTheme.accent)
                                    } else {
                                        Image(systemName: "chevron.right")
                                            .font(.caption.weight(.bold))
                                            .foregroundStyle(AppTheme.secondaryText)
                                    }
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                                .background(
                                    code == selectedCode
                                        ? AppTheme.accent.opacity(0.12)
                                        : AppTheme.elevatedBackground,
                                    in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(code == selectedCode ? AppTheme.accent.opacity(0.6) : AppTheme.border, lineWidth: 1)
                                }
                            }
                            .buttonStyle(.plain)
                        }

                        if filteredCodes.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                    .font(.title2)
                                Text(L10n.t("No currencies found", language: appLanguage))
                                    .font(.subheadline.weight(.medium))
                            }
                            .foregroundStyle(AppTheme.secondaryText)
                            .padding(.top, 40)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
        }
    }

    private var filteredCodes: [String] {
        let sortedCodes = codes.sorted {
            let firstFavorite = favoriteCodes.contains($0)
            let secondFavorite = favoriteCodes.contains($1)
            if firstFavorite != secondFavorite {
                return firstFavorite && !secondFavorite
            }
            return $0 < $1
        }

        guard !searchText.isEmpty else { return sortedCodes }
        return sortedCodes.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
}
