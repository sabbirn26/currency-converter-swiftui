//
//  AmountCardView.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import SwiftUI

struct AmountCardView: View {
    @Binding var amountText: String
    @FocusState.Binding var isFocused: Bool
    let onChange: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Amount")
                .font(.custom("American Typewriter", size: 12))
                .foregroundColor(.white.opacity(0.65))

            TextField("Enter an amount", text: $amountText)
                .keyboardType(.decimalPad)
                .focused($isFocused)
                .font(.custom("American Typewriter", size: 20))
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .onChange(of: amountText) { _ in
                    onChange()
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
}
