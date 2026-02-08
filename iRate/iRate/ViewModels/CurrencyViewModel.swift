//
//  CurrencyViewModel.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import Foundation
import Combine

final class CurrencyViewModel: ObservableObject {
    @Published var baseAmount = "1.0"
    @Published var baseCr = "BDT"
    @Published var desCrCode = "USD"

    @Published var onlyCrCodes = [String]()
    @Published var fullList = [String]()
    @Published var result = ""

    @Published var isPayloadCall = false
    @Published var errorAlert = false
    @Published var handleError: ErrorType?

    private let apiErrorText = "API error occurred"
    private let validationErrorText = "Please enter a valid amount"

    enum ErrorType {
        case apiError
        case inputError
    }

    var errorMessage: String {
        handleError == .apiError ? apiErrorText : validationErrorText
    }

    func validation() {
        if baseAmount.hasPrefix(".") {
            baseAmount = "0" + baseAmount
        }

        guard let amount = parsedAmount(), amount > 0 else {
            errorAlert = true
            handleError = .inputError
            return
        }

        makeRequest(amount: amount)
    }

    @MainActor
    func refresh() async {
        validation()
    }

    private func parsedAmount() -> Double? {
        let trimmed = baseAmount.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty || trimmed == "." { return nil }
        return Double(trimmed)
    }

    private func makeRequest(amount: Double) {
        isPayloadCall = true
        onlyCrCodes.removeAll()
        fullList.removeAll()

        apiRequest(url: "https://v6.exchangerate-api.com/v6/80a68197fb86c8427589c1a4/latest/\(baseCr)") { [weak self] currencyData in
            guard let self = self else { return }
            guard let currency = currencyData, let rates = currency.conversionRates else {
                self.isPayloadCall = false
                self.errorAlert = true
                self.handleError = .apiError
                return
            }

            if !currency.success {
                self.isPayloadCall = false
                self.errorAlert = true
                self.handleError = .apiError
                return
            }

            let codes = rates.keys.sorted()
            self.onlyCrCodes = codes

            if let rate = rates[self.desCrCode] {
                let converted = rate * amount
                self.result = "\(self.desCrCode) \(String(format: "%.2f", converted))"
            } else {
                self.result = ""
            }

            for code in codes {
                if let rate = rates[code] {
                    let convertedValue = rate * amount
                    self.fullList.append("\(code) \(String(format: "%.2f", convertedValue))")
                }
            }

            self.isPayloadCall = false
            self.errorAlert = false
        }
    }
}
