//
//  HeaderView.swift
//  iRate
//
//  Created by Codex on 2/8/26.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
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
}
