//
//  ButtonsDemoView.swift
//  SwiftUiViews
//
//  Demo: custom styles (glass / blur / material), HIG-aligned animations and haptics.
//

import SwiftUI

struct ButtonsDemoView: View {
    @State private var showExpandableFAB = false
    @State private var fabExpanded = false
    @State private var animateSections = false

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                higSection
                primarySecondarySection
                systemStylesSection
                glassSection
                expandableFABSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.platformGroupedBackground)
            .navigationTitle("Buttons")
            .platformInlineTitleMode()
            .onAppear {
                guard !animateSections else { return }
                withAnimation(.spring(response: 0.45, dampingFraction: 0.84)) {
                    animateSections = true
                }
            }
            .overlay {
                if showExpandableFAB {
                    ExpandableFABView(
                        isExpanded: $fabExpanded,
                        mainIcon: "plus",
                        items: expandableFABItems
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }

    private var expandableFABItems: [ExpandableFABItem] {
        [
            ExpandableFABItem(icon: "square.and.arrow.up", label: "Share", action: {}),
            ExpandableFABItem(icon: "heart.fill", label: "Like", action: {}),
            ExpandableFABItem(icon: "star.fill", label: "Favorite", action: {})
        ]
    }

    // MARK: - HIG (Human Interface Guidelines)

    private var higSection: some View {
        DemoCard(
            title: "UX Principles",
            subtitle: "Hierarchy, contrast, motion and feedback",
            isVisible: animateSections,
            delay: 0.0
        ) {
            VStack(alignment: .leading, spacing: 8) {
                higRow(icon: "hand.tap", text: "Tap targets stay comfortable and obvious")
                higRow(icon: "waveform", text: "Haptics only on meaningful actions")
                higRow(icon: "figure.walk", text: "Reduce Motion respected")
                higRow(icon: "paintbrush", text: "Clear visual hierarchy: primary > secondary > tertiary")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }

    private func higRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .frame(width: 20, alignment: .center)
            Text(text)
        }
    }

    // MARK: - Primary, Secondary and Card

    private var primarySecondarySection: some View {
        DemoCard(
            title: "Action Hierarchy",
            subtitle: "Use one prominent action per context",
            isVisible: animateSections,
            delay: 0.05
        ) {
            VStack(alignment: .leading, spacing: 6) {
                Button("Continue") {}
                    .buttonStyle(.primary)
                Text("Primary action")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            VStack(alignment: .leading, spacing: 6) {
                Button("Save for later") {}
                    .buttonStyle(.secondaryBordered)
                Text("Secondary action")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            VStack(alignment: .leading, spacing: 6) {
                Button("Open details") {}
                    .buttonStyle(.cardPinch)
                Text("Card-like contextual action")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    // MARK: - Expandable FAB

    private var expandableFABSection: some View {
        DemoCard(
            title: "Expandable FAB",
            subtitle: "Use when quick actions should stay near the main context",
            isVisible: animateSections,
            delay: 0.20
        ) {
            Toggle("Show floating actions", isOn: $showExpandableFAB)
                .tint(.accentColor)
        }
    }

    // MARK: - System styles

    private var systemStylesSection: some View {
        DemoCard(
            title: "System Styles",
            subtitle: "Prefer built-in styles for consistency",
            isVisible: animateSections,
            delay: 0.10
        ) {
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Button("Bordered", systemImage: "square.and.arrow.up") {}
                        .buttonStyle(.bordered)
                    Button("Prominent", systemImage: "checkmark.circle.fill") {}
                        .buttonStyle(.borderedProminent)
                }

                HStack(spacing: 10) {
                    Button("Borderless", systemImage: "link") {}
                        .buttonStyle(.borderless)
                    Button("Plain", systemImage: "gearshape") {}
                        .buttonStyle(.plain)
                }

                HStack(spacing: 12) {
                    Button { } label: { Image(systemName: "plus.circle.fill") }
                        .buttonStyle(.bordered)
                    Button { } label: { Image(systemName: "heart.fill") }
                        .buttonStyle(.borderedProminent)
                    Button { } label: { Image(systemName: "square.and.arrow.up") }
                        .buttonStyle(.plain)
                }
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    // MARK: - Glass (iOS 26)

    private var glassSection: some View {
        DemoCard(
            title: "Glass (iOS 26)",
            subtitle: "Use sparingly for controls and navigation emphasis",
            isVisible: animateSections,
            delay: 0.15
        ) {
            GlassEffectContainer(spacing: 16) {
                glassButtons
            }
        }
    }

    private var glassButtons: some View {
        VStack(spacing: 12) {
            Button("Glass Action", systemImage: "sparkles") {}
                .buttonStyle(.glass)
            Button("Glass Prominent", systemImage: "checkmark") {}
                .buttonStyle(.glassProminent)
            Button("Glass Secondary", systemImage: "star.fill") {}
                .buttonStyle(.glass)
            HStack(spacing: 12) {
                Button { } label: { Image(systemName: "plus") }
                    .buttonStyle(.glass)
                Button { } label: { Image(systemName: "heart.fill") }
                    .buttonStyle(.glassProminent)
                Button { } label: { Image(systemName: "shareplay") }
                    .buttonStyle(.glass)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

private struct DemoCard<Content: View>: View {
    let title: String
    let subtitle: String
    let isVisible: Bool
    let delay: Double
    @ViewBuilder let content: Content

    init(
        title: String,
        subtitle: String,
        isVisible: Bool,
        delay: Double,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isVisible = isVisible
        self.delay = delay
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            content
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(.white.opacity(0.12), lineWidth: 1)
        )
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 16)
        .animation(.spring(response: 0.45, dampingFraction: 0.86).delay(delay), value: isVisible)
    }
}

#Preview {
    NavigationStack {
        ButtonsDemoView()
    }
}
