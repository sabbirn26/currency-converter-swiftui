//
//  SettingsView.swift
//  iRate
//

import SwiftUI

struct SettingsView: View {
    let showsCloseButton: Bool
    @Environment(\.dismiss) private var dismiss
    @AppStorage(AppStorageKeys.appLanguage) private var appLanguage = "en"
    @AppStorage(AppStorageKeys.appTheme) private var appTheme = AppThemeMode.system.rawValue
    @AppStorage(AppStorageKeys.hapticsEnabled) private var hapticsEnabled = true

    private let defaultURL = URL(string: "https://google.com/")!
    private let linkedinURL = URL(string: "https://www.linkedin.com/in/sabbirn26/")!
    private let personalURL = URL(string: "https://github.com/sabbirn26")!

    init(showsCloseButton: Bool = true) {
        self.showsCloseButton = showsCloseButton
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                VStack(spacing: 18) {
                    headerCard

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 18) {
                            appearanceCard
                            preferencesCard
                            developerCard
                            linksCard
                        }
                        .padding(.bottom, 32)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
            .navigationTitle(L10n.t("Settings", language: appLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                if showsCloseButton {
                    ToolbarItem(placement: .topBarLeading) {
                        XmarkButton {
                            dismiss()
                        }
                    }
                }
            }
        }
        .tint(AppTheme.accentDeep)
    }
}

private extension SettingsView {
    var headerCard: some View {
        HStack(spacing: 16) {
            Image("icon")
                .resizable()
                .scaledToFit()
                .frame(width: 74, height: 74)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                }
                .shadow(color: AppTheme.accent.opacity(0.22), radius: 12, y: 6)

            VStack(alignment: .leading, spacing: 6) {
                Text("iRate")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText)

                Text(L10n.t("Fast, focused currency conversion.", language: appLanguage))
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer()
        }
        .padding(18)
        .appCard(cornerRadius: 24)
    }

    var appearanceCard: some View {
        SettingsCard(title: L10n.t("Appearance", language: appLanguage), icon: "circle.lefthalf.filled") {
            Picker(L10n.t("Appearance", language: appLanguage), selection: $appTheme) {
                ForEach(AppThemeMode.allCases) { mode in
                    Text(L10n.t(mode.localizationKey, language: appLanguage))
                        .tag(mode.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: appTheme) { _ in
                Haptics.selection()
            }
        }
    }

    var preferencesCard: some View {
        SettingsCard(title: L10n.t("Preferences", language: appLanguage), icon: "switch.2") {
            VStack(spacing: 0) {
                SettingsToggleRow(
                    title: L10n.t("Haptic feedback", language: appLanguage),
                    subtitle: L10n.t("Feel subtle feedback for key actions.", language: appLanguage),
                    icon: "waveform",
                    isOn: $hapticsEnabled
                )
                .onChange(of: hapticsEnabled) { enabled in
                    if enabled {
                        Haptics.success()
                    }
                }

                Divider()
                    .overlay(AppTheme.border)
                    .padding(.vertical, 12)

                SettingsToggleRow(
                    title: L10n.t("Bangla", language: appLanguage),
                    subtitle: L10n.t("Switch the app language.", language: appLanguage),
                    icon: "character.book.closed",
                    isOn: isBanglaBinding
                )
            }
        }
    }

    var developerCard: some View {
        SettingsCard(title: L10n.t("Developer", language: appLanguage), icon: "hammer") {
            VStack(alignment: .leading, spacing: 14) {
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 14) {
                        developerPhoto
                        developerDescription
                            .frame(minWidth: 200)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        developerPhoto
                        developerDescription
                    }
                }

                Link(destination: personalURL) {
                    SettingsLinkRow(
                        title: L10n.t("GitHub Profile", language: appLanguage),
                        icon: "chevron.left.forwardslash.chevron.right"
                    )
                }

                Link(destination: linkedinURL) {
                    SettingsLinkRow(
                        title: L10n.t("LinkedIn Profile", language: appLanguage),
                        icon: "person.crop.circle"
                    )
                }
            }
        }
    }

    var developerPhoto: some View {
        Image("devPhoto")
            .resizable()
            .scaledToFill()
            .frame(width: 76, height: 76)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            }
    }

    var developerDescription: some View {
        Text(L10n.t("I'm Sabbir, a software engineer and content creator, constantly exploring new technologies. This project is part of my learning journey, built entirely with Swift and SwiftUI.", language: appLanguage))
            .font(.subheadline)
            .foregroundStyle(AppTheme.secondaryText)
            .fixedSize(horizontal: false, vertical: true)
    }

    var linksCard: some View {
        SettingsCard(title: L10n.t("Application", language: appLanguage), icon: "info.circle") {
            VStack(spacing: 10) {
                Link(destination: defaultURL) {
                    SettingsLinkRow(title: L10n.t("Terms of Service", language: appLanguage), icon: "doc.text")
                }
                Link(destination: defaultURL) {
                    SettingsLinkRow(title: L10n.t("Privacy Policy", language: appLanguage), icon: "hand.raised")
                }
                Link(destination: defaultURL) {
                    SettingsLinkRow(title: L10n.t("Company Website", language: appLanguage), icon: "globe")
                }
                Link(destination: defaultURL) {
                    SettingsLinkRow(title: L10n.t("Learn More", language: appLanguage), icon: "sparkles")
                }
            }
        }
    }

    var isBanglaBinding: Binding<Bool> {
        Binding(
            get: { appLanguage == "bn" },
            set: { value in
                appLanguage = value ? "bn" : "en"
                Haptics.selection()
            }
        )
    }
}

private struct SettingsCard<Content: View>: View {
    let title: String
    let icon: String
    let content: Content

    init(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundStyle(AppTheme.primaryText)
                .symbolRenderingMode(.hierarchical)

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .appCard(cornerRadius: 24)
    }
}

private struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.accentDeep)
                    .frame(width: 36, height: 36)
                    .background(AppTheme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 11, style: .continuous))

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.primaryText)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }
        }
        .tint(AppTheme.accent)
    }
}

private struct SettingsLinkRow: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppTheme.accentDeep)
                .frame(width: 32)

            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppTheme.primaryText)

            Spacer()

            Image(systemName: "arrow.up.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.secondaryText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 11)
        .background(AppTheme.secondaryBackground, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

#Preview {
    SettingsView()
}
