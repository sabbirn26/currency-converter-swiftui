//
//  ToastModifier.swift
//  iRate
//
//  Created by Codex on 2/8/26.
//

import SwiftUI

enum ToastPosition {
    case top
    case middle
    case bottom
}

private struct ToastModifier<ToastContent: View>: ViewModifier {
    @Binding var showToast: Bool
    let position: ToastPosition
    let toastContent: () -> ToastContent

    func body(content: Content) -> some View {
        ZStack {
            content

            if showToast {
                toastContent()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 6)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .frame(maxHeight: .infinity, alignment: alignment)
                    .transition(.opacity.combined(with: .move(edge: edge)))
                    .animation(.easeInOut(duration: 0.2), value: showToast)
            }
        }
    }

    private var alignment: Alignment {
        switch position {
        case .top: return .top
        case .middle: return .center
        case .bottom: return .bottom
        }
    }

    private var edge: Edge {
        switch position {
        case .top: return .top
        case .middle: return .bottom
        case .bottom: return .bottom
        }
    }
}

extension View {
    func toast<ToastContent: View>(
        showToast: Binding<Bool>,
        position: ToastPosition = .bottom,
        @ViewBuilder toastContent: @escaping () -> ToastContent
    ) -> some View {
        modifier(ToastModifier(showToast: showToast, position: position, toastContent: toastContent))
    }
}
