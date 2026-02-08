//
//  iRateLogoView.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import SwiftUI

struct iRateLogoView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.22),
                            Color.white.opacity(0.05)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 96, height: 96)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )

            VStack(spacing: 2) {
                Text("i")
                    .font(.custom("American Typewriter", size: 24))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text("Rate")
                    .font(.custom("American Typewriter", size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
    }
}

#Preview {
    iRateLogoView()
        .padding()
        .background(Color.black)
}
