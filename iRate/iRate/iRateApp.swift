//
//  iRateApp.swift
//  iRate
//
//  Created by Sabbir Nasir on 8/2/26.
//

import SwiftUI

@main
struct iRateApp: App {
    @AppStorage(AppStorageKeys.appTheme) private var appTheme = AppThemeMode.system.rawValue

    init() {
        UserDefaults.standard.register(defaults: [
            AppStorageKeys.appTheme: AppThemeMode.system.rawValue,
            AppStorageKeys.appLanguage: "en",
            AppStorageKeys.hapticsEnabled: true
        ])
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(
                    AppThemeMode(rawValue: appTheme)?.colorScheme
                )
        }
    }
}
