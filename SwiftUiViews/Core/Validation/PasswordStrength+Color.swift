//
//  PasswordStrength+Color.swift
//  SwiftUiViews
//
//  UI mapping: strength → border color (frontend convention).
//  Red = weak, Orange = fair, Green = good/strong, nil = empty.
//

import SwiftUI

extension PasswordStrength {
    /// Border color for password field; nil when empty (use default border).
    var borderColor: Color? {
        switch self {
        case .empty: return nil
        case .weak: return .red
        case .fair: return .orange
        case .good, .strong: return .green
        }
    }
}
