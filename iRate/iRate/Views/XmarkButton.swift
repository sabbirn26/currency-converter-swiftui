//
//  XmarkButton.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import SwiftUI

struct XmarkButton: View {
    let dismiss: () -> Void

    var body: some View {
        Button(action: dismiss) {
            Image(systemName: "xmark")
                .font(.headline)
                .foregroundStyle(AppTheme.primaryText)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(AppTheme.secondaryBackground)
                        .overlay {
                            Circle().stroke(AppTheme.border, lineWidth: 1)
                        }
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    XmarkButton(dismiss: {})
        .padding()
        .background(Color.blue)
}
