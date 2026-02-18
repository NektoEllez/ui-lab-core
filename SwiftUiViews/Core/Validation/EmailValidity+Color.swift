//
//  EmailValidity+Color.swift
//  SwiftUiViews
//
//  UI mapping: validity → border color (same convention as password).
//  Red = invalid, Green = valid, nil = empty.
//

import SwiftUI

extension EmailValidity {
    /// Border color for email field; nil when empty (use default border).
    var borderColor: Color? {
        switch self {
        case .empty: return nil
        case .invalid: return .red
        case .valid: return .green
        }
    }
}
