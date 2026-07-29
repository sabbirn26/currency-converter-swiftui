//
//  Currency.swift
//  iRate
//
//  Created by Sabbir Nasir on 8/2/26.
//

import Foundation

struct Currency: Codable {
    let result: String?
    let baseCode: String?
    let timeLastUpdateUTC: String?
    let timeNextUpdateUTC: String?
    let timeLastUpdateUnix: TimeInterval?
    let conversionRates: [String: Double]?

    var success: Bool { result == "success" }

    enum CodingKeys: String, CodingKey {
        case result
        case baseCode = "base_code"
        case timeLastUpdateUTC = "time_last_update_utc"
        case timeNextUpdateUTC = "time_next_update_utc"
        case timeLastUpdateUnix = "time_last_update_unix"
        case conversionRates = "conversion_rates"
    }
}

enum CurrencyServiceError: Error {
    case invalidURL
    case invalidResponse
    case apiFailure
}

protocol CurrencyServiceProtocol {
    func fetchRates(baseCode: String) async throws -> Currency
}

struct CurrencyService: CurrencyServiceProtocol {
    func fetchRates(baseCode: String) async throws -> Currency {
        guard let requestURL = URL(
            string: "https://v6.exchangerate-api.com/v6/80a68197fb86c8427589c1a4/latest/\(baseCode)"
        ) else {
            throw CurrencyServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: requestURL)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw CurrencyServiceError.invalidResponse
        }

        let currency = try JSONDecoder().decode(Currency.self, from: data)
        guard currency.success,
              let rates = currency.conversionRates,
              !rates.isEmpty else {
            throw CurrencyServiceError.apiFailure
        }
        return currency
    }
}
