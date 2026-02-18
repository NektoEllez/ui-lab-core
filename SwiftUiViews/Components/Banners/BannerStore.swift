//
//  BannerStore.swift
//  SwiftUiViews
//
//  @Observable store for banner visibility and content (optional global use).
//

import SwiftUI

@Observable
@MainActor
final class BannerStore {
    var current: BannerItem?

    func show(_ item: BannerItem) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            current = item
        }
    }

    func dismiss() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            current = nil
        }
    }
}

struct BannerItem {
    let title: String
    let message: String?
    let style: BannerStyle
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        title: String,
        message: String? = nil,
        style: BannerStyle = .info,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.style = style
        self.actionTitle = actionTitle
        self.action = action
    }
}

enum BannerStyle {
    case info
    case success
    case warning
    case error
}
