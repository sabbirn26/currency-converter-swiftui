//
//  CircleButtonView.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String

    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(AppTheme.primaryText)
            .frame(width: 40, height: 40)
            .background {
                Circle()
                    .fill(AppTheme.elevatedBackground)
                    .overlay {
                        Circle().stroke(AppTheme.border, lineWidth: 1)
                    }
            }
            .shadow(color: AppTheme.shadow, radius: 10, y: 5)
            .padding()
    }
}

#Preview {
    CircleButtonView(iconName: "info")
}
