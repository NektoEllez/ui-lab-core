//
//  ListRow.swift
//  SwiftUiViews
//
//  Reusable list row component: icon, title, subtitle, chevron.
//  Best practice: stable identity, decomposed, no inline logic.
//

import SwiftUI

struct ListRow: View {
    let icon: String?
    let title: String
    let subtitle: String?
    let showChevron: Bool
    var tintColor: Color = .accentColor
    let action: () -> Void

    init(
        icon: String? = nil,
        title: String,
        subtitle: String? = nil,
        showChevron: Bool = true,
        tintColor: Color = .accentColor,
        action: @escaping () -> Void = {}
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.showChevron = showChevron
        self.tintColor = tintColor
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            rowContent
        }
        .buttonStyle(MenuRowButtonStyle())
    }

    // MARK: - Private subviews

    private var rowContent: some View {
        HStack(spacing: Constants.contentSpacing) {
            leadingIcon
            textContent
            Spacer(minLength: Constants.spacerMinLength)
            trailingChevron
        }
        .padding(.vertical, Constants.verticalPadding)
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private var leadingIcon: some View {
        if let icon {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(tintColor)
                .frame(width: Constants.iconSize, height: Constants.iconSize)
        }
    }

    private var textContent: some View {
        VStack(alignment: .leading, spacing: Constants.textSpacing) {
            titleText
            subtitleText
        }
    }

    private var titleText: some View {
        Text(title)
            .font(.body.weight(.medium))
            .foregroundStyle(.primary)
    }

    @ViewBuilder
    private var subtitleText: some View {
        if let subtitle {
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var trailingChevron: some View {
        if showChevron {
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
    }
}

// MARK: - Constants

private enum Constants {
    static let contentSpacing: CGFloat = 12
    static let iconSize: CGFloat = 28
    static let textSpacing: CGFloat = 2
    static let verticalPadding: CGFloat = 8
    static let spacerMinLength: CGFloat = 8
}

#Preview("ListRow with icon") {
    List {
        ListRow(
            icon: "envelope",
            title: "Messages",
            subtitle: "3 unread",
            action: {}
        )
        ListRow(
            icon: "bell",
            title: "Notifications",
            subtitle: "5 new",
            tintColor: .orange,
            action: {}
        )
    }
}

#Preview("ListRow without icon") {
    List {
        ListRow(
            title: "Privacy Policy",
            subtitle: "Updated Jan 2026",
            action: {}
        )
        ListRow(
            title: "Settings",
            showChevron: false,
            action: {}
        )
    }
}
