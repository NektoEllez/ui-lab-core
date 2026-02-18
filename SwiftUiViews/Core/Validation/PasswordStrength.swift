//
//  PasswordStrength.swift
//  SwiftUiViews
//
//  Domain-layer password strength: pure, synchronous, hint only (no UI).
//  Frontend-style: weak/fair/good/strong with short hints instead of errors while typing.
//  Border color mapping lives in PasswordStrength+Color (SwiftUI).
//

import Foundation

/// Password strength level for real-time feedback (no error, just hint + border color).
enum PasswordStrength {
    case empty
    case weak
    case fair
    case good
    case strong

    /// Short hint shown below field while typing; nil when empty.
    var hint: String? {
        switch self {
        case .empty: return nil
        case .weak: return "Too short"
        case .fair: return "Add letters and numbers"
        case .good: return "Good"
        case .strong: return "Strong"
        }
    }

    /// Evaluate strength from password (length + character variety). Pure function.
    static func evaluate(_ password: String) -> PasswordStrength {
        let len = password.count
        if len == 0 { return .empty }
        if len < 6 { return .weak }

        let hasLower = password.contains { $0.isLetter && $0.isLowercase }
        let hasUpper = password.contains { $0.isLetter && $0.isUppercase }
        let hasDigit = password.contains { $0.isNumber }
        let hasSymbol = password.contains { !$0.isLetter && !$0.isNumber }
        let variety = [hasLower, hasUpper, hasDigit, hasSymbol].filter { $0 }.count

        if len >= 8 && variety >= 3 { return .strong }
        if len >= 6 && variety >= 2 { return .good }
        if len >= 6 { return .fair }
        return .weak
    }
}
