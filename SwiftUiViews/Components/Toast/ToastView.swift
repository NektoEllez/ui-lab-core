//
//  ToastView.swift
//  SwiftUiViews
//
//  Single toast appearance: icon, text, style.
//

import SwiftUI

struct ToastView: View {
    let message: ToastMessage
    let onDismiss: () -> Void

    var body: some View {
        Button(action: onDismiss) {
            toastContent
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .glassStyleBackground(cornerRadius: 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(iconColor.opacity(0.35), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(message.text)
        .accessibilityHint("Double tap to dismiss")
    }

    private var toastContent: some View {
        HStack(spacing: 12) {
            toastIconView
            Text(message.text)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
            Spacer(minLength: 0)
        }
    }

    @ViewBuilder
    private var toastIconView: some View {
        if let icon = message.icon {
            Image(systemName: icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(iconColor)
        }
    }

    private var iconColor: Color {
        switch message.style {
        case .default: return .secondary
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        }
    }

    private var backgroundColor: Color {
        switch message.style {
        case .default: return Color.platformSecondarySystemBackground
        case .success: return Color.green.opacity(0.15)
        case .warning: return Color.orange.opacity(0.15)
        case .error: return Color.red.opacity(0.15)
        }
    }
}

#Preview("ToastView") {
    ToastView(
        message: ToastMessage(text: "Saved successfully.", icon: "checkmark.circle", style: .success),
        onDismiss: {}
    )
    .padding()
}
