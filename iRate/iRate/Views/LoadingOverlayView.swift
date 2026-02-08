//
//  LoadingOverlayView.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import SwiftUI

struct LoadingOverlayView: View {
    @Binding var isLoading: Bool

    var body: some View {
        if isLoading {
            ZStack {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                ActivityIndicator(isAnimating: $isLoading, style: .large, color: .white)
            }
        }
    }
}
