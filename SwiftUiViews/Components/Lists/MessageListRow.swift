//
//  MessageListRow.swift
//  SwiftUiViews
//
//  Settings-style row: icon (left, tinted), title bold, subtitle below, disclosure chevron.
//  Use inside card sections with dividers between rows.
//

import SwiftUI

struct MessageListRow: View {
    let title: String
    let preview: String?
    let leadingImage: String?
    var trailingText: String? = nil
    var isUnread: Bool = false
    var showChevron: Bool = true
    let action: () -> Void

    init(
        title: String,
        preview: String? = nil,
        leadingImage: String? = nil,
        trailingText: String? = nil,
        isUnread: Bool = false,
        showChevron: Bool = true,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.preview = preview
        self.leadingImage = leadingImage
        self.trailingText = trailingText
        self.isUnread = isUnread
        self.showChevron = showChevron
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            rowContent
        }
        .buttonStyle(.plain)
        .animation(Constants.readTransitionAnimation, value: isUnread)
    }

    private var rowContent: some View {
        HStack(alignment: .center, spacing: Constants.contentSpacing) {
            leadingView
            textBlock
            Spacer(minLength: Constants.spacerMinLength)
            if let trailingText {
                Text(trailingText)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, Constants.verticalPadding)
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private var leadingView: some View {
        if let leadingImage {
            Image(systemName: leadingImage)
                .font(.title2)
                .foregroundStyle(isUnread ? Constants.unreadIconColor : Constants.readIconColor)
                .frame(width: Constants.leadingSize, height: Constants.leadingSize)
        }
    }

    private var textBlock: some View {
        VStack(alignment: .leading, spacing: Constants.textSpacing) {
            Text(title)
                .font(.body.weight(isUnread ? .semibold : .medium))
                .foregroundStyle(.primary)
                .lineLimit(1)
            if let preview {
                Text(preview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Constants

private enum Constants {
    static let contentSpacing: CGFloat = 12
    static let leadingSize: CGFloat = 40
    static let textSpacing: CGFloat = 2
    static let verticalPadding: CGFloat = 12
    static let spacerMinLength: CGFloat = 8
    static let unreadIconColor = Color.orange
    static let readIconColor = Color.blue
    static let readTransitionAnimation = Animation.spring(response: 0.48, dampingFraction: 0.86)
}

#Preview("MessageListRow") {
    List {
        MessageListRow(
            title: "John Doe",
            preview: "Thanks for the update. I'll review it by tomorrow.",
            leadingImage: "person.circle.fill",
            trailingText: "10:42",
            isUnread: true,
            action: {}
        )
        MessageListRow(
            title: "Team",
            preview: "Meeting at 3 PM in Room B.",
            leadingImage: "person.3.fill",
            trailingText: "Yesterday",
            action: {}
        )
    }
    .listStyle(.plain)
}
