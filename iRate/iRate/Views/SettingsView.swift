//
//  SettingsView.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    let defaultURL = URL(string: "https://google.com/")!
    let githubURL = URL(string: "https://youtube.com/")!
    let linkedinURL = URL(string: "https://www.linkedin.com/in/sabbirn26/")!
    let personalURL = URL(string: "https://github.com/sabbirn26")!

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        headerCard
                        developerCard
                        linksCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkButton(dismiss: xButtonAction)
                }
            }
        }
        .tint(.white)
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            iRateLogoView()

            Text("About iRate")
                .font(.custom("American Typewriter", size: 18))
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text("iRate is a sleek currency converter built with SwiftUI. It fetches live exchange rates, lets you swap currencies instantly, and surfaces results in a clean, modern interface. The app is designed to be fast and simple: pick your currencies, enter an amount, and see conversions at a glance.")
                .font(.custom("American Typewriter", size: 14))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.10))
        )
    }

    private var developerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Developer")
                .font(.custom("American Typewriter", size: 18))
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Image("devPhoto")
                .resizable()
                .scaledToFill()
                .frame(width: 96, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )

            Text("I'm Sabbir, a software engineer and content creator, constantly exploring new technologies. This project is part of my learning journey, built entirely with Swift and SwiftUI.")
                .font(.custom("American Typewriter", size: 14))
                .foregroundColor(.white.opacity(0.8))

            VStack(alignment: .leading, spacing: 8) {
                Link(destination: personalURL) {
                    SettingsLinkRow(title: "GitHub Profile")
                }
                Link(destination: linkedinURL) {
                    SettingsLinkRow(title: "LinkedIn Profile")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.10))
        )
    }

    private var linksCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Application")
                .font(.custom("American Typewriter", size: 18))
                .fontWeight(.semibold)
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 8) {
                Link(destination: defaultURL) {
                    SettingsLinkRow(title: "Terms of Service")
                }
                Link(destination: defaultURL) {
                    SettingsLinkRow(title: "Privacy Policy")
                }
                Link(destination: defaultURL) {
                    SettingsLinkRow(title: "Company Website")
                }
                Link(destination: defaultURL) {
                    SettingsLinkRow(title: "Learn More")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.10))
        )
    }

    private func xButtonAction() {
        presentationMode.wrappedValue.dismiss()
    }
}

private struct SettingsLinkRow: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.custom("American Typewriter", size: 14))
                .foregroundColor(.white)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.7))
                .font(.system(size: 12, weight: .semibold))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.08))
        )
    }
}
