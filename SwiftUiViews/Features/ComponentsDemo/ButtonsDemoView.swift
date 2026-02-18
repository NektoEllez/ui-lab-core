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

    var body: some View {
        buttonsList
            .navigationTitle("Buttons")
            .platformInlineTitleMode()
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

    private var buttonsList: some View {
        List {
            higSection
            primarySecondarySection
            cardPinchSection
            expandableFABSection
            systemStylesSection
            glassSection
        }
    }

    // MARK: - HIG (Human Interface Guidelines)

    private var higSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 10) {
                Label("HIG‑aligned", systemImage: "checkmark.seal.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                VStack(alignment: .leading, spacing: 6) {
                    higRow(icon: "hand.tap", text: "Purposeful animation (<400ms)")
                    higRow(icon: "waveform", text: "Haptic feedback (light / selection)")
                    higRow(icon: "figure.walk", text: "Reduce Motion: scale off when enabled")
                    higRow(icon: "paintbrush", text: "Contrast: dark button → light text, light → dark text")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        } header: {
            Text("Human Interface Guidelines")
        }
    }

    private func higRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .frame(width: 20, alignment: .center)
            Text(text)
        }
    }

    // MARK: - Primary & Secondary (glass vs blur)

    private var primarySecondarySection: some View {
        Section {
            VStack(alignment: .leading, spacing: 6) {
                Button("Primary — glass + bounce") {}
                    .buttonStyle(.primary)
                Text("Black/white fill · Spring 0.28 · scale 0.96 · light haptic")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 4, trailing: 16))
            .listRowBackground(Color.clear)

            VStack(alignment: .leading, spacing: 6) {
                Button("Secondary — blur + snappy") {}
                    .buttonStyle(.secondaryBordered)
                Text("UltraThinMaterial · Snappy 0.18 · scale 0.97 · selection haptic")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 10, trailing: 16))
            .listRowBackground(Color.clear)
        } header: {
            Text("Primary & secondary")
        }
    }

    // MARK: - Card Pinch (material)

    private var cardPinchSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 6) {
                Button("Card — material + soft spring") {}
                    .buttonStyle(.cardPinch)
                Text("RegularMaterial · Spring 0.35 · scale 0.98 · light haptic")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
            .listRowBackground(Color.clear)
        } header: {
            Text("Card Pinch")
        }
    }

    // MARK: - Expandable FAB (круглая кнопка, по нажатию — три «крудочки»)

    private var expandableFABSection: some View {
        Section {
            Toggle("Show expandable FAB", isOn: $showExpandableFAB)
        } header: {
            Text("Expandable FAB")
        } footer: {
            Text("Round button at bottom. Tap to show three crumb buttons to the left. Tap outside to collapse. iOS 26 glass when available.")
        }
    }

    // MARK: - System styles

    private var systemStylesSection: some View {
        Section {
            Button("Bordered", systemImage: "square.and.arrow.up") {}
                .buttonStyle(.bordered)
            Button("Bordered prominent", systemImage: "checkmark.circle") {}
                .buttonStyle(.borderedProminent)
            Button("Borderless", systemImage: "link") {}
                .buttonStyle(.borderless)
            Button("Plain", systemImage: "gearshape") {}
                .buttonStyle(.plain)
            HStack(spacing: 12) {
                Button { } label: { Image(systemName: "plus.circle") }
                    .buttonStyle(.bordered)
                Button { } label: { Image(systemName: "heart") }
                    .buttonStyle(.borderedProminent)
                Button { } label: { Image(systemName: "square.and.arrow.up") }
                    .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity)
        } header: {
            Text("System styles")
        } footer: {
            Text("Bordered, borderedProminent, borderless, plain. Bottom row: icon-only.")
        }
    }

    // MARK: - Glass (iOS 26)

    private var glassSection: some View {
        Section {
            GlassEffectContainer(spacing: 16) {
                glassButtons
            }
        } header: {
            Text("Glass (iOS 26)")
        } footer: {
            Text("Liquid Glass: .glass, .glassProminent. Wrap in GlassEffectContainer for shared context.")
        }
    }

    private var glassButtons: some View {
        VStack(spacing: 12) {
            Button("Glass", systemImage: "sparkles") {}
                .buttonStyle(.glass)
            Button("Glass prominent", systemImage: "checkmark") {}
                .buttonStyle(.glassProminent)
            Button("Glass with label", systemImage: "star.fill") {}
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

#Preview {
    NavigationStack {
        ButtonsDemoView()
    }
}
