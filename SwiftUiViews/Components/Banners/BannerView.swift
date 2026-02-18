//
//  BannerView.swift
//  SwiftUiViews
//
//  Single banner: title, message, action button, close.
//

import SwiftUI

struct BannerView: View {
    let item: BannerItem
    let onDismiss: () -> Void

    var body: some View {
        bannerContent
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassStyleBackground(cornerRadius: 12)
            .overlay(borderOverlay)
            .clipShape(.rect(cornerRadius: 12))
    }

    private var bannerContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            headerRow
            actionButton
        }
    }

    private var headerRow: some View {
        HStack(alignment: .top) {
            iconView
            titleBlock
            dismissButton
        }
    }

    private var iconView: some View {
        Image(systemName: iconName)
            .font(.title3.weight(.semibold))
            .foregroundStyle(iconColor)
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)
            messageText
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var messageText: some View {
        if let message = item.message {
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var dismissButton: some View {
        Button { onDismiss() } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .accessibilityLabel("Dismiss banner")
    }

    @ViewBuilder
    private var actionButton: some View {
        if let actionTitle = item.actionTitle, item.action != nil {
            Button(actionTitle) {
                item.action?()
                onDismiss()
            }
            .buttonStyle(.bordered)
            .tint(iconColor)
        }
    }

    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .strokeBorder(borderColor.opacity(0.5), lineWidth: 1)
    }

    private var iconName: String {
        switch item.style {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        }
    }

    private var iconColor: Color {
        switch item.style {
        case .info: return .blue
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        }
    }

    private var backgroundColor: Color {
        switch item.style {
        case .info: return Color.blue.opacity(0.1)
        case .success: return Color.green.opacity(0.1)
        case .warning: return Color.orange.opacity(0.1)
        case .error: return Color.red.opacity(0.1)
        }
    }

    private var borderColor: Color {
        switch item.style {
        case .info: return .blue
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        }
    }
}

#Preview("BannerView") {
    BannerView(
        item: BannerItem(
            title: "Success",
            message: "Your changes have been saved.",
            style: .success,
            actionTitle: "Dismiss"
        ) {},
        onDismiss: {}
    )
    .padding()
}
