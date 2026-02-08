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
    let conversionRates: [String: Double]?

    var success: Bool { result == "success" }

    enum CodingKeys: String, CodingKey {
        case result
        case baseCode = "base_code"
        case timeLastUpdateUTC = "time_last_update_utc"
        case timeNextUpdateUTC = "time_next_update_utc"
        case conversionRates = "conversion_rates"
    }
}

func apiRequest(url: String, completion: @escaping (Currency?) -> ()) {
    guard let requestURL = URL(string: url) else {
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: requestURL) { data, response, error in
        if let error = error {
            print(error)
            DispatchQueue.main.async { completion(nil) }
            return
        }

        guard let data = data else {
            DispatchQueue.main.async { completion(nil) }
            return
        }

        do {
            let decoded = try JSONDecoder().decode(Currency.self, from: data)
            DispatchQueue.main.async { completion(decoded) }
        } catch {
            print(error)
            DispatchQueue.main.async { completion(nil) }
        }
    }.resume()
}
