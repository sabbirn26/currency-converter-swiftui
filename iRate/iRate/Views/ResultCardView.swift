//
//  ResultCardView.swift
//  iRate
//
//  Created by Codex on 2/8/26.
//

import SwiftUI

struct ResultCardView: View {
    let resultText: String
    @State private var bump = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Converted")
                .font(.custom("Avenir Next", size: 12))
                .foregroundColor(.white.opacity(0.65))

            Text(resultText.isEmpty ? "—" : resultText)
                .font(.custom("Avenir Next", size: 24))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .scaleEffect(bump ? 1.03 : 1.0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.12))
        )
        .onChange(of: resultText) { _ in
            withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                bump = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                    bump = false
                }
            }
        }
    }
}
