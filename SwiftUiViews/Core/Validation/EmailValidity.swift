//
//  EmailValidity.swift
//  SwiftUiViews
//
//  Domain-layer email validity: pure, synchronous, hint only (no UI).
//  Same pattern as password strength: short hint + border color while typing.
//

import Foundation

/// Email validity level for real-time feedback (no error, just hint + border color).
enum EmailValidity {
    case empty
    case invalid
    case valid

    /// Short hint shown below field while typing; nil when empty.
    var hint: String? {
        switch self {
        case .empty: return nil
        case .invalid: return "Add a valid email"
        case .valid: return "Looks good"
        }
    }

    /// Evaluate validity from email (format only). Pure function.
    static func evaluate(_ email: String) -> EmailValidity {
        let t = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if t.isEmpty { return .empty }
        if t.contains("@"), t.contains("."), t.first != "@", t.last != "@", t.last != "." {
            return .valid
        }
        return .invalid
    }
}
