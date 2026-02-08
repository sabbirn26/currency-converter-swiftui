//
//  CurrencyCardView.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import SwiftUI

struct CurrencyCardView: View {
    let title: String
    let code: String
    let accent: Color
    let onTap: () -> Void
    @AppStorage("appLanguage") private var appLanguage = "en"

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.t(title, language: appLanguage))
                    .font(.custom("American Typewriter", size: 12))
                    .foregroundColor(.white.opacity(0.65))

                HStack(spacing: 8) {
                    Text(CurrencyFlag.emoji(for: code))
                        .font(.system(size: 18))

                    Text(code)
                        .font(.custom("American Typewriter", size: 20))
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
}
