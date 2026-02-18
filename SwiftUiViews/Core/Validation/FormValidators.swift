//
//  FormValidators.swift
//  SwiftUiViews
//
//  Domain-layer validation: pure, synchronous, side-effect free.
//  Reusable across features (TextFields demo, Bottom Bar, any form).
//  Clean Architecture: validation is business logic, not UI.
//

import Foundation

enum FormValidators {
    /// Returns error message if invalid, nil if valid.
    static func validateEmail(_ email: String) -> String? {
        let t = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if t.isEmpty { return "Email is required" }
        if !t.contains("@") { return "Invalid email" }
        if !t.contains(".") { return "Invalid email" }
        return nil
    }

    /// Returns error message if invalid, nil if valid.
    static func validatePassword(_ password: String, minLength: Int = 6) -> String? {
        if password.isEmpty { return "Password is required" }
        if password.count < minLength {
            return "Password must be at least \(minLength) characters"
        }
        return nil
    }

    /// Returns error message if empty, nil if valid.
    static func validateRequired(_ value: String, fieldName: String = "Field") -> String? {
        if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "\(fieldName) is required"
        }
        return nil
    }
}
