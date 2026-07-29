//
//  Haptics.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import UIKit

enum Haptics {
    private static var isEnabled: Bool {
        let defaults = UserDefaults.standard
        guard defaults.object(forKey: AppStorageKeys.hapticsEnabled) != nil else {
            return true
        }
        return defaults.bool(forKey: AppStorageKeys.hapticsEnabled)
    }

    static func selection() {
        guard isEnabled else { return }
        UISelectionFeedbackGenerator().selectionChanged()
    }

    static func lightImpact() {
        guard isEnabled else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func success() {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func error() {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
