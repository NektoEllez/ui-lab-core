//
//  EmptyStateView.swift
//  SwiftUiViews
//
//  Empty state for lists: icon, title, message, optional action button.
//  Best practice: decomposed, clear hierarchy.
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: Constants.contentSpacing) {
            emptyIcon
            emptyTitle
            emptyMessage
            actionButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .multilineTextAlignment(.center)
        .padding(Constants.containerPadding)
    }

    // MARK: - Private subviews

    private var emptyIcon: some View {
        Image(systemName: icon)
            .font(.system(size: Constants.iconSize))
            .foregroundStyle(.secondary)
    }

    private var emptyTitle: some View {
        Text(title)
            .font(.title2.weight(.semibold))
            .foregroundStyle(.primary)
    }

    private var emptyMessage: some View {
        Text(message)
            .font(.body)
            .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private var actionButton: some View {
        if let actionTitle, let action {
            Button(actionTitle, action: action)
                .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Constants

private enum Constants {
    static let contentSpacing: CGFloat = 16
    static let iconSize: CGFloat = 64
    static let containerPadding: CGFloat = 40
}

#Preview("EmptyStateView") {
    EmptyStateView(
        icon: "tray",
        title: "No Items",
        message: "You don't have any items yet. Tap the button below to add your first item.",
        actionTitle: "Add Item"
    ) {}
}
