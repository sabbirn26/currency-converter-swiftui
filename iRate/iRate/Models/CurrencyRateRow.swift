//
//  CurrencyRateRow.swift
//  iRate
//

import Foundation

struct CurrencyRateRow: Identifiable, Equatable {
    let code: String
    let rate: Double
    let convertedValue: Double?
    let isFavorite: Bool

    var id: String { code }
    var flag: String { CurrencyFlag.emoji(for: code) }
}
