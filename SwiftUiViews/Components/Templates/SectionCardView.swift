//
//  SectionCardView.swift
//  SwiftUiViews
//
//  Generic card section with optional subtitle and trailing action.
//

import SwiftUI

struct SectionCardView<Content: View>: View {
    let title: String
    let subtitle: String?
    let actionTitle: String?
    let action: (() -> Void)?
    @ViewBuilder let content: () -> Content

    init(
        title: String,
        subtitle: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer(minLength: 8)
                if let actionTitle, let action {
                    Button(actionTitle, action: action)
                        .buttonStyle(.borderless)
                        .font(.subheadline.weight(.semibold))
                }
            }
            content()
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.regularMaterial)
        }
    }
}

#Preview("Section Card") {
    SectionCardView(
        title: "Account",
        subtitle: "Main profile settings",
        actionTitle: "Edit",
        action: {}
    ) {
        VStack(alignment: .leading, spacing: 6) {
            Text("Name: Alex")
            Text("Plan: Pro")
        }
        .font(.subheadline)
    }
    .padding()
}
