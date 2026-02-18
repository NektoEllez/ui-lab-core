//
//  BottomBarView.swift
//  SwiftUiViews
//
//  Footer with primary/secondary buttons; optional iOS 26 glass style.
//

import SwiftUI

struct BottomBarView<Content: View>: View {
    @ViewBuilder let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        styledContent
    }

    private var styledContent: some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .glassStyleBar()
    }
}

struct BottomBarPrimaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            buttonLabel
        }
        .buttonStyle(.borderedProminent)
    }

    @ViewBuilder
    private var buttonLabel: some View {
        Group {
            if let icon {
                Label(title, systemImage: icon)
            } else {
                Text(title)
            }
        }
        .font(.body.weight(.semibold))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }
}

struct BottomBarSecondaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            buttonLabel
        }
        .buttonStyle(.bordered)
    }

    @ViewBuilder
    private var buttonLabel: some View {
        Group {
            if let icon {
                Label(title, systemImage: icon)
            } else {
                Text(title)
            }
        }
        .font(.body.weight(.medium))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }
}

// MARK: - Previews

#Preview("BottomBarView") {
    BottomBarView {
        VStack(spacing: 12) {
            Button("Continue") { }
                .buttonStyle(.primary)
        }
    }
    .padding()
}

#Preview("BottomBarPrimaryButton") {
    BottomBarPrimaryButton(title: "Continue", action: {})
        .padding()
}

#Preview("BottomBarSecondaryButton") {
    BottomBarSecondaryButton(title: "Cancel", action: {})
        .padding()
}
