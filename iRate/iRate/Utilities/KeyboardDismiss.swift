//
//  KeyboardDismiss.swift
//  iRate
//
//  Created by Sabbir Nasir on 2/8/26.
//

import UIKit
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
