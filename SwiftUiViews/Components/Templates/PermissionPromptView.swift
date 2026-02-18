//
//  PermissionPromptView.swift
//  SwiftUiViews
//
//  Reusable permission prompt used for camera/notifications/location access.
//

import SwiftUI

struct PermissionPromptView: View {
    let icon: String
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.tint)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button(buttonTitle, action: action)
                .buttonStyle(.borderedProminent)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.thinMaterial)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview("Permission Prompt") {
    PermissionPromptView(
        icon: "bell.badge.fill",
        title: "Enable notifications",
        message: "Get real-time updates and reminders.",
        buttonTitle: "Allow",
        action: {}
    )
    .padding()
}
