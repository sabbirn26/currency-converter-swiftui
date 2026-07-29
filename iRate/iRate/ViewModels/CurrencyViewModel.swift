//
//  CurrencyViewModel.swift
//  iRate
//

import Foundation
import Combine

@MainActor
final class CurrencyViewModel: ObservableObject {
    enum LoadState: Equatable {
        case idle
        case initialLoading
        case loaded
        case refreshing
        case failed
    }

    @Published var baseAmount = "1.0"
    @Published private(set) var baseCr = "BDT"
    @Published private(set) var desCrCode = "USD"
    @Published private(set) var rates: [String: Double] = [:]
    @Published private(set) var lastUpdated: Date?
    @Published private(set) var loadState: LoadState = .idle
    @Published private(set) var favoriteCodes: Set<String>

    private let service: CurrencyServiceProtocol
    private let defaults: UserDefaults
    private var activeRequestID: UUID?
    private var requestTask: Task<Currency, Error>?

    init(
        service: CurrencyServiceProtocol = CurrencyService(),
        defaults: UserDefaults = .standard
    ) {
        self.service = service
        self.defaults = defaults
        favoriteCodes = Self.loadFavorites(from: defaults)
    }

    var onlyCrCodes: [String] {
        rates.keys.sorted()
    }

    var parsedAmount: Double? {
        let trimmed = baseAmount.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed != ".", let amount = Double(trimmed), amount > 0 else {
            return nil
        }
        return amount
    }

    var hasValidAmount: Bool {
        parsedAmount != nil
    }

    var convertedAmount: Double? {
        guard let amount = parsedAmount, let rate = rates[desCrCode] else { return nil }
        return amount * rate
    }

    var result: String {
        guard let convertedAmount else { return "" }
        return "\(desCrCode) \(Self.formatAmount(convertedAmount))"
    }

    var exchangeRateText: String {
        guard let rate = rates[desCrCode] else { return "" }
        return "1 \(baseCr) = \(Self.formatRate(rate)) \(desCrCode)"
    }

    var favoriteRows: [CurrencyRateRow] {
        rows.filter(\.isFavorite)
    }

    var allRows: [CurrencyRateRow] {
        rows.filter { !$0.isFavorite }
    }

    var isInitialLoading: Bool {
        loadState == .initialLoading
    }

    var isRefreshing: Bool {
        loadState == .refreshing
    }

    var hasError: Bool {
        loadState == .failed
    }

    func loadInitial() async {
        guard rates.isEmpty, loadState != .initialLoading else { return }
        _ = await requestRates(
            baseCode: baseCr,
            destinationCode: nil,
            initial: true
        )
    }

    func refresh() async {
        _ = await requestRates(
            baseCode: baseCr,
            destinationCode: nil,
            initial: rates.isEmpty
        )
    }

    func retry() async {
        _ = await requestRates(
            baseCode: baseCr,
            destinationCode: nil,
            initial: rates.isEmpty
        )
    }

    func updateAmount(_ value: String) {
        if value.hasPrefix(".") {
            baseAmount = "0" + value
        } else {
            baseAmount = value
        }
    }

    func selectQuickAmount(_ amount: Double) {
        baseAmount = String(format: "%.0f", amount)
    }

    func selectDestination(_ code: String) {
        guard rates[code] != nil else { return }
        desCrCode = code
    }

    func selectBase(_ code: String) async {
        guard code != baseCr else {
            cancelPendingRequest()
            return
        }
        _ = await requestRates(
            baseCode: code,
            destinationCode: nil,
            initial: rates.isEmpty
        )
    }

    func swapCurrencies() async {
        _ = await requestRates(
            baseCode: desCrCode,
            destinationCode: baseCr,
            initial: rates.isEmpty
        )
    }

    func toggleFavorite(_ code: String) {
        if favoriteCodes.contains(code) {
            favoriteCodes.remove(code)
        } else {
            favoriteCodes.insert(code)
        }
        persistFavorites()
    }

    func lastUpdatedText(language: String) -> String? {
        guard let lastUpdated else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: language == "bn" ? "bn_BD" : "en_US")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: lastUpdated)
    }

    private var rows: [CurrencyRateRow] {
        rates.keys.sorted().compactMap { code in
            guard let rate = rates[code] else { return nil }
            return CurrencyRateRow(
                code: code,
                rate: rate,
                convertedValue: parsedAmount.map { $0 * rate },
                isFavorite: favoriteCodes.contains(code)
            )
        }
    }

    private func requestRates(
        baseCode requestedBaseCode: String,
        destinationCode requestedDestinationCode: String?,
        initial: Bool
    ) async -> Bool {
        requestTask?.cancel()
        let requestID = UUID()
        activeRequestID = requestID
        loadState = initial ? .initialLoading : .refreshing

        let task = Task {
            try await service.fetchRates(baseCode: requestedBaseCode)
        }
        requestTask = task

        do {
            let currency = try await task.value
            guard activeRequestID == requestID else { return false }
            rates = currency.conversionRates ?? [:]
            lastUpdated = currency.timeLastUpdateUnix.map(Date.init(timeIntervalSince1970:))
            baseCr = requestedBaseCode
            if let requestedDestinationCode {
                desCrCode = requestedDestinationCode
            }
            activeRequestID = nil
            loadState = .loaded
            return true
        } catch is CancellationError {
            return false
        } catch {
            guard activeRequestID == requestID else { return false }
            activeRequestID = nil
            loadState = .failed
            return false
        }
    }

    private func persistFavorites() {
        let values = Array(favoriteCodes).sorted()
        if let data = try? JSONEncoder().encode(values) {
            defaults.set(data, forKey: AppStorageKeys.favoriteCurrencies)
        }
    }

    private func cancelPendingRequest() {
        guard activeRequestID != nil else { return }
        requestTask?.cancel()
        activeRequestID = nil
        loadState = rates.isEmpty ? .idle : .loaded
    }

    private static func loadFavorites(from defaults: UserDefaults) -> Set<String> {
        guard let data = defaults.data(forKey: AppStorageKeys.favoriteCurrencies),
              let values = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return Set(values)
    }

    private static func formatAmount(_ value: Double) -> String {
        String(format: "%.2f", value)
    }

    private static func formatRate(_ value: Double) -> String {
        if value >= 1 {
            return String(format: "%.2f", value)
        }
        return String(format: "%.4f", value)
    }
}
