//
//  HideKeyboardExtension.swift
//  Devote
//
//  Created by Ada Yagiz Gur on 19.02.2023.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
