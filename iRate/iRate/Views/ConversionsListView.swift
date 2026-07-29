//
//  ConversionsListView.swift
//  iRate
//

import SwiftUI

struct ConversionsListView: View {
    let title: String
    let items: [CurrencyRateRow]
    let onSelect: (String) -> Void
    let onFavorite: (String) -> Void
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.primaryText)

                Spacer()

                Text("\(items.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.accentDeep)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(AppTheme.accent.opacity(0.12), in: Capsule())
            }

            LazyVStack(spacing: 10) {
                ForEach(items) { item in
                    rateRow(item)
                }
            }
        }
        .padding(16)
        .appCard(cornerRadius: 24)
    }

    private func rateRow(_ item: CurrencyRateRow) -> some View {
        HStack(spacing: 8) {
            Button {
                onSelect(item.code)
            } label: {
                HStack(spacing: 12) {
                    Text(item.flag)
                        .font(.system(size: 25))
                        .frame(width: 42, height: 42)
                        .background(AppTheme.secondaryBackground, in: Circle())

                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.code)
                            .font(.system(.body, design: .rounded, weight: .bold))
                            .foregroundStyle(AppTheme.primaryText)

                        Text(L10n.t("Tap to convert", language: appLanguage))
                            .font(.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 3) {
                        Text(formattedValue(item.convertedValue))
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .foregroundStyle(AppTheme.primaryText)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)

                        Text(L10n.format("Rate %@", language: appLanguage, formattedRate(item.rate)))
                            .font(.caption2)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(item.code), \(formattedValue(item.convertedValue))")

            Button {
                onFavorite(item.code)
            } label: {
                Image(systemName: item.isFavorite ? "star.fill" : "star")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(item.isFavorite ? AppTheme.warning : AppTheme.secondaryText)
                    .frame(width: 36, height: 36)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(
                L10n.t(
                    item.isFavorite ? "Remove from favorites" : "Add to favorites",
                    language: appLanguage
                )
            )
        }
        .padding(12)
        .background(AppTheme.secondaryBackground.opacity(0.72), in: RoundedRectangle(cornerRadius: 17, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 17, style: .continuous)
                .stroke(AppTheme.border.opacity(0.8), lineWidth: 1)
        }
    }

    private func formattedValue(_ value: Double?) -> String {
        guard let value else { return "—" }
        return String(format: "%.2f", value)
    }

    private func formattedRate(_ value: Double) -> String {
        value >= 1 ? String(format: "%.2f", value) : String(format: "%.4f", value)
    }
}
