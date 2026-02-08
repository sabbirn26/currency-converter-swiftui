//
//  ResultCardView.swift
//  iRate
//
//  Created by Codex on 2/8/26.
//

import SwiftUI

struct ResultCardView: View {
    let resultText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Converted")
                .font(.custom("Avenir Next", size: 12))
                .foregroundColor(.white.opacity(0.65))

            Text(resultText.isEmpty ? "—" : resultText)
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
}
