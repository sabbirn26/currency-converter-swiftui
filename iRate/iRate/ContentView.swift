//
//  ContentView.swift
//  iRate
//
//  Created by Sabbir Nasir on 8/2/26.
//

import SwiftUI

struct ContentView: View {
    @State private var baseAmount = "1.0"
    @State private var baseCr = "BDT"
    @State private var desCrCode = "USD"

    @State private var onlyCrCodes = [String]()
    @State private var fullList = [String]()
    @State private var result = ""

    @State private var isPayloadCall = false
    @State private var errorAlert = false
    @State private var handleError: ErrorType?

    @FocusState private var focusedInput: Bool

    @State private var searchCr = ""
    @State private var activeSheet: PickerTarget?

    private let apiErrorText = "API error occurred"
    private let validationErrorText = "Please enter a valid amount"

    enum PickerTarget: Identifiable {
        case base
        case destination

        var id: Int { self == .base ? 0 : 1 }
    }

    enum ErrorType {
        case apiError
        case inputError
    }

    private var gradientBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.08, green: 0.10, blue: 0.16),
                Color(red: 0.10, green: 0.15, blue: 0.25),
                Color(red: 0.13, green: 0.20, blue: 0.30)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private func parsedAmount() -> Double? {
        let trimmed = baseAmount.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty || trimmed == "." { return nil }
        return Double(trimmed)
    }

    private func validation() {
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

    private func makeRequest(amount: Double) {
        isPayloadCall = true
        onlyCrCodes.removeAll()
        fullList.removeAll()

        apiRequest(url: "https://v6.exchangerate-api.com/v6/80a68197fb86c8427589c1a4/latest/\(baseCr)") { currencyData in
            guard let currency = currencyData, let rates = currency.conversionRates else {
                isPayloadCall = false
                errorAlert = true
                handleError = .apiError
                return
            }

            if !currency.success {
                isPayloadCall = false
                errorAlert = true
                handleError = .apiError
                return
            }

            let codes = rates.keys.sorted()
            onlyCrCodes = codes

            if let rate = rates[desCrCode] {
                let converted = rate * amount
                result = "\(desCrCode) \(String(format: "%.2f", converted))"
            } else {
                result = ""
            }

            for code in codes {
                if let rate = rates[code] {
                    let convertedValue = rate * amount
                    fullList.append("\(code) \(String(format: "%.2f", convertedValue))")
                }
            }

            isPayloadCall = false
            errorAlert = false
        }
    }

    var body: some View {
        ZStack {
            gradientBackground

            VStack(spacing: 20) {
                header
                currencySelector
                amountCard
                resultCard
                conversionsList
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)

            if isPayloadCall {
                loadingOverlay
            }
        }
        .sheet(item: $activeSheet) { target in
            CurrencyPickerSheet(
                title: target == .base ? "Your currency" : "To currency",
                searchText: $searchCr,
                codes: onlyCrCodes,
                onSelect: { code in
                    if target == .base {
                        baseCr = code
                    } else {
                        desCrCode = code
                    }
                    searchCr = ""
                    activeSheet = nil
                    validation()
                }
            )
            .presentationDetents([.medium, .large])
        }
        .onAppear {
            validation()
        }
        .toast(showToast: $errorAlert, position: .middle) {
            Text(handleError == .apiError ? apiErrorText : validationErrorText)
                .font(.custom("Avenir Next", size: 14))
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("iRate")
                .font(.custom("Avenir Next", size: 28))
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Currency conversion in a glance")
                .font(.custom("Avenir Next", size: 14))
                .foregroundColor(.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var currencySelector: some View {
        HStack(spacing: 14) {
            currencyCard(
                title: "From",
                code: baseCr,
                accent: Color(red: 0.40, green: 0.78, blue: 0.95)
            ) {
                focusedInput = false
                activeSheet = .base
            }

            swapIcon

            currencyCard(
                title: "To",
                code: desCrCode,
                accent: Color(red: 0.98, green: 0.61, blue: 0.38)
            ) {
                focusedInput = false
                activeSheet = .destination
            }
        }
    }

    private var swapIcon: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 38, height: 38)

            Image(systemName: "arrow.left.arrow.right")
                .foregroundColor(.white.opacity(0.9))
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(.top, 12)
    }

    private func currencyCard(title: String, code: String, accent: Color, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.custom("Avenir Next", size: 12))
                    .foregroundColor(.white.opacity(0.65))

                HStack(spacing: 8) {
                    Text(code)
                        .font(.custom("Avenir Next", size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Image(systemName: "chevron.down")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 12, weight: .semibold))
                }

                Capsule()
                    .fill(accent)
                    .frame(width: 36, height: 4)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.10))
            )
        }
        .buttonStyle(.plain)
    }

    private var amountCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Amount")
                .font(.custom("Avenir Next", size: 12))
                .foregroundColor(.white.opacity(0.65))

            TextField("Enter an amount", text: $baseAmount)
                .keyboardType(.decimalPad)
                .focused($focusedInput)
                .font(.custom("Avenir Next", size: 20))
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .onChange(of: baseAmount) { _ in
                    validation()
                }

            Divider()
                .background(Color.white.opacity(0.2))
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.10))
        )
    }

    private var resultCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Converted")
                .font(.custom("Avenir Next", size: 12))
                .foregroundColor(.white.opacity(0.65))

            Text(result.isEmpty ? "—" : result)
                .font(.custom("Avenir Next", size: 24))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.12))
        )
    }

    private var conversionsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All rates")
                .font(.custom("Avenir Next", size: 14))
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.85))

            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(fullList, id: \.self) { currency in
                        HStack {
                            Text(currency)
                                .font(.custom("Avenir Next", size: 14))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.08))
                        )
                    }
                }
            }
        }
        .padding(.bottom, 20)
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()
            ActivityIndicator(isAnimating: $isPayloadCall, style: .large, color: .white)
        }
    }
}

private struct CurrencyPickerSheet: View {
    let title: String
    @Binding var searchText: String
    let codes: [String]
    let onSelect: (String) -> Void

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
                Capsule()
                    .fill(Color.white.opacity(0.35))
                    .frame(width: 48, height: 5)
                    .padding(.top, 8)

                Text(title)
                    .font(.custom("Avenir Next", size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.7))
                    TextField("Search currency", text: $searchText)
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
                            HStack {
                                Text(code)
                                    .font(.custom("Avenir Next", size: 16))
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
