//
//  L10n.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import Foundation

enum L10n {
    static func t(_ key: String, language: String) -> String {
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(key, bundle: bundle, comment: "")
        }
        return NSLocalizedString(key, comment: "")
    }
}
