//
//  iRateTests.swift
//  iRateTests
//

import XCTest
@testable import iRate

final class iRateTests: XCTestCase {
    @MainActor
    func testLocalConversionAndAmountValidation() async {
        let defaults = makeDefaults()
        let viewModel = CurrencyViewModel(
            service: TestCurrencyService { baseCode in
                makeCurrency(baseCode: baseCode, rates: ["BDT": 1, "USD": 0.01])
            },
            defaults: defaults
        )

        await viewModel.loadInitial()
        viewModel.updateAmount("250")

        XCTAssertEqual(viewModel.result, "USD 2.50")
        XCTAssertTrue(viewModel.hasValidAmount)

        viewModel.updateAmount(".")

        XCTAssertEqual(viewModel.result, "")
        XCTAssertFalse(viewModel.hasValidAmount)
    }

    @MainActor
    func testSwapLoadsNewBaseAndKeepsLocalPrecision() async {
        let defaults = makeDefaults()
        let viewModel = CurrencyViewModel(
            service: TestCurrencyService { baseCode in
                if baseCode == "USD" {
                    return makeCurrency(baseCode: "USD", rates: ["USD": 1, "BDT": 100])
                }
                return makeCurrency(baseCode: "BDT", rates: ["BDT": 1, "USD": 0.01])
            },
            defaults: defaults
        )

        await viewModel.loadInitial()
        await viewModel.swapCurrencies()

        XCTAssertEqual(viewModel.baseCr, "USD")
        XCTAssertEqual(viewModel.desCrCode, "BDT")
        XCTAssertEqual(viewModel.result, "BDT 100.00")
    }

    @MainActor
    func testFavoritesPersistAndAreSeparatedFromAllRows() async {
        let defaults = makeDefaults()
        let service = TestCurrencyService { baseCode in
            makeCurrency(
                baseCode: baseCode,
                rates: ["BDT": 1, "EUR": 0.008, "USD": 0.01]
            )
        }
        let viewModel = CurrencyViewModel(service: service, defaults: defaults)

        await viewModel.loadInitial()
        viewModel.toggleFavorite("EUR")

        XCTAssertEqual(viewModel.favoriteRows.map(\.code), ["EUR"])
        XCTAssertFalse(viewModel.allRows.map(\.code).contains("EUR"))

        let restoredViewModel = CurrencyViewModel(service: service, defaults: defaults)
        XCTAssertTrue(restoredViewModel.favoriteCodes.contains("EUR"))
    }

    @MainActor
    func testLastUpdatedUsesAPITimestamp() async {
        let defaults = makeDefaults()
        let timestamp: TimeInterval = 1_722_254_400
        let viewModel = CurrencyViewModel(
            service: TestCurrencyService { baseCode in
                makeCurrency(
                    baseCode: baseCode,
                    rates: ["BDT": 1, "USD": 0.01],
                    timestamp: timestamp
                )
            },
            defaults: defaults
        )

        await viewModel.loadInitial()

        XCTAssertEqual(viewModel.lastUpdated, Date(timeIntervalSince1970: timestamp))
        XCTAssertNotNil(viewModel.lastUpdatedText(language: "en"))
        XCTAssertNotNil(viewModel.lastUpdatedText(language: "bn"))
    }

    @MainActor
    func testLatestBaseRequestWins() async {
        let defaults = makeDefaults()
        let viewModel = CurrencyViewModel(
            service: TestCurrencyService { baseCode in
                if baseCode == "EUR" {
                    try await Task.sleep(nanoseconds: 200_000_000)
                }
                return makeCurrency(
                    baseCode: baseCode,
                    rates: [baseCode: 1, "BDT": baseCode == "BDT" ? 1 : 100, "USD": 1]
                )
            },
            defaults: defaults
        )

        await viewModel.loadInitial()

        let slowRequest = Task {
            await viewModel.selectBase("EUR")
        }
        try? await Task.sleep(nanoseconds: 20_000_000)
        await viewModel.selectBase("USD")
        await slowRequest.value

        XCTAssertEqual(viewModel.baseCr, "USD")
        XCTAssertEqual(viewModel.rates["USD"], 1)
        XCTAssertEqual(viewModel.loadState, .loaded)
    }

    private func makeDefaults() -> UserDefaults {
        let suiteName = "iRateTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}

private struct TestCurrencyService: CurrencyServiceProtocol {
    let response: (String) async throws -> Currency

    func fetchRates(baseCode: String) async throws -> Currency {
        try await response(baseCode)
    }
}

private func makeCurrency(
    baseCode: String,
    rates: [String: Double],
    timestamp: TimeInterval = 1_722_254_400
) -> Currency {
    Currency(
        result: "success",
        baseCode: baseCode,
        timeLastUpdateUTC: nil,
        timeNextUpdateUTC: nil,
        timeLastUpdateUnix: timestamp,
        conversionRates: rates
    )
}
