//
//  HeaderView.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import SwiftUI

struct HeaderView: View {
    @AppStorage("appLanguage") private var appLanguage = "en"

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("iRate")
                .font(.custom("American Typewriter", size: 28))
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(L10n.t("Currency conversion in a glance", language: appLanguage))
                .font(.custom("American Typewriter", size: 14))
                .foregroundColor(.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
