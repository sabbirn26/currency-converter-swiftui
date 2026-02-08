//
//  ConversionsListView.swift
//  iRate
//
//  Created by Codex on 2/8/26.
//

import SwiftUI

struct ConversionsListView: View {
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All rates")
                .font(.custom("Avenir Next", size: 14))
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.85))

            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(items, id: \.self) { currency in
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
}
