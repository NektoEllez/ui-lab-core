//
//  PlatformUI.swift
//  SwiftUiViews
//
//  Cross-platform helpers for colors and platform-specific view modifiers.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
    static var platformSystemBackground: Color {
        #if canImport(UIKit)
        Color(uiColor: .systemBackground)
        #elseif canImport(AppKit)
        Color(nsColor: .windowBackgroundColor)
        #else
        Color.white
        #endif
    }

    static var platformGroupedBackground: Color {
        #if canImport(UIKit)
        Color(uiColor: .systemGroupedBackground)
        #elseif canImport(AppKit)
        Color(nsColor: .controlBackgroundColor)
        #else
        Color.gray.opacity(0.12)
        #endif
    }

    static var platformSecondarySystemBackground: Color {
        #if canImport(UIKit)
        Color(uiColor: .secondarySystemBackground)
        #elseif canImport(AppKit)
        Color(nsColor: .underPageBackgroundColor)
        #else
        Color.gray.opacity(0.18)
        #endif
    }

    static var platformSecondaryFill: Color {
        #if canImport(UIKit)
        Color(uiColor: .secondarySystemFill)
        #elseif canImport(AppKit)
        Color(nsColor: .quaternaryLabelColor).opacity(0.15)
        #else
        Color.gray.opacity(0.14)
        #endif
    }
}

extension View {
    @ViewBuilder
    func platformInlineTitleMode() -> some View {
        #if os(iOS) || os(tvOS) || os(visionOS)
        navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }

    @ViewBuilder
    func platformLargeTitleMode() -> some View {
        #if os(iOS) || os(tvOS) || os(visionOS)
        navigationBarTitleDisplayMode(.large)
        #else
        self
        #endif
    }

    @ViewBuilder
    func platformInsetGroupedListStyle() -> some View {
        #if os(iOS) || os(tvOS) || os(visionOS)
        listStyle(.insetGrouped)
        #else
        listStyle(.automatic)
        #endif
    }
}
