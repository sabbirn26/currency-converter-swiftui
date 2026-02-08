//
//  ConversionsListView.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import SwiftUI

struct ConversionsListView: View {
    let items: [String]
    let onRefresh: () async -> Void
    @AppStorage("appLanguage") private var appLanguage = "en"

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack{
            Text(L10n.t("All rates", language: appLanguage))
                .font(.custom("American Typewriter", size: 14))
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.85))
                Spacer()
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(items, id: \.self) { currency in
                        HStack {
                            Text(currency)
                                .font(.custom("American Typewriter", size: 14))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.08))
                        )
                        .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: items)
            }
            .refreshable {
                await onRefresh()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
