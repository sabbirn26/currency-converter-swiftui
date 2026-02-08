//
//  AppBackgroundView.swift
//  iRate
//
//  Created by Codex on 2/8/26.
//

import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
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
}
