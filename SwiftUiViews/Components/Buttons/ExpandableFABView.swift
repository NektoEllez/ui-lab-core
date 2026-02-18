//
//  ExpandableFABView.swift
//  SwiftUiViews
//
//  Floating action button: round, centered on screen. On tap — "crumb" buttons appear
//  on an orbit around it (center stays fixed). Overlay on full screen. iOS 26–style glass when available.
//

import SwiftUI

struct ExpandableFABItem: Identifiable {
    let id: String
    let icon: String
    let label: String
    let action: () -> Void

    init(
        id: String? = nil,
        icon: String,
        label: String,
        action: @escaping () -> Void
    ) {
        self.id = id ?? "\(icon)|\(label)"
        self.icon = icon
        self.label = label
        self.action = action
    }
}

struct ExpandableFABConfiguration {
    let mainSize: CGFloat
    let crumbSize: CGFloat
    let orbitRadius: CGFloat
    let orbitAngles: [Double]
    let fallbackArcSpan: Double

    static let `default` = ExpandableFABConfiguration(
        mainSize: 56,
        crumbSize: 44,
        orbitRadius: 72,
        orbitAngles: [45, 0, -45],
        fallbackArcSpan: 90
    )
}

struct ExpandableFABView: View {
    @Binding var isExpanded: Bool
    let mainIcon: String
    let items: [ExpandableFABItem]
    let configuration: ExpandableFABConfiguration
    private let tapManager = ButtonTapManager.shared
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(
        isExpanded: Binding<Bool>,
        mainIcon: String,
        items: [ExpandableFABItem],
        configuration: ExpandableFABConfiguration = .default
    ) {
        self._isExpanded = isExpanded
        self.mainIcon = mainIcon
        self.items = items
        self.configuration = configuration
    }

    var body: some View {
        ZStack {
            if isExpanded {
                Color.clear
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(expandAnimation) { isExpanded = false }
                    }
            }

            mainButtonContainer
                .animation(expandAnimation, value: isExpanded)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
    }

    /// Fixed-size container so FAB stays centered when overlay (crumbs) appears.
    private var mainButtonContainer: some View {
        ZStack {
            mainButton
            crumbButtonsOverlay
        }
        .frame(width: configuration.mainSize, height: configuration.mainSize)
    }

    private var mainButton: some View {
        Button {
            guard tapManager.shouldHandleTap(id: "expandable-fab-main") else { return }
            withAnimation(expandAnimation) { isExpanded.toggle() }
        } label: {
            Image(systemName: isExpanded ? "xmark" : mainIcon)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.background)
                .frame(width: configuration.mainSize, height: configuration.mainSize)
                .contentShape(Circle())
                .contentTransition(.symbolEffect(.replace))
                .background(mainButtonBackground)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isExpanded ? "Close actions" : "Open actions")
        .accessibilityHint("Shows quick action buttons")
    }

    @ViewBuilder
    private var mainButtonBackground: some View {
        if #available(iOS 26, *) {
            Circle()
                .fill(.clear)
                .glassEffect(.regular.tint(.primary), in: Circle())
        } else {
            Circle()
                .fill(.primary)
        }
    }

    @ViewBuilder
    private var crumbButtonsOverlay: some View {
        if isExpanded {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                crumbButton(item: item)
                    .offset(crumbOffset(for: index))
            }
        }
    }

    private func crumbOffset(for index: Int) -> CGSize {
        let angleDeg: Double
        if items.count <= configuration.orbitAngles.count, index < configuration.orbitAngles.count {
            angleDeg = configuration.orbitAngles[index]
        } else {
            let step = items.count > 1 ? configuration.fallbackArcSpan / Double(items.count - 1) : 0
            angleDeg = 45 - Double(index) * step
        }
        let angleRad = angleDeg * .pi / 180
        let x = configuration.orbitRadius * cos(angleRad)
        let y = -configuration.orbitRadius * sin(angleRad)
        return CGSize(width: x, height: y)
    }

    private func crumbButton(item: ExpandableFABItem) -> some View {
        Button {
            guard tapManager.shouldHandleTap(id: "expandable-fab-item-\(item.id)") else { return }
            withAnimation(expandAnimation) { isExpanded = false }
            item.action()
        } label: {
            Image(systemName: item.icon)
                .font(.body.weight(.medium))
                .foregroundStyle(.primary)
                .frame(width: configuration.crumbSize, height: configuration.crumbSize)
                .background(crumbBackground)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(item.label)
        .accessibilityHint("Runs \(item.label.lowercased()) action")
        .transition(crumbTransition)
    }

    @ViewBuilder
    private var crumbBackground: some View {
        if #available(iOS 26, *) {
            Circle()
                .fill(.clear)
                .glassEffect(.regular, in: Circle())
        } else {
            Circle()
                .fill(.regularMaterial)
        }
    }

    private var expandAnimation: Animation {
        .spring(response: 0.35, dampingFraction: 0.8)
    }

    private var crumbTransition: AnyTransition {
        reduceMotion ? .opacity : .scale(scale: 0.5).combined(with: .opacity)
    }
}

#Preview("Expandable FAB") {
    struct PreviewWrapper: View {
        @State private var expanded = false
        var body: some View {
            Color.platformGroupedBackground
                .overlay {
                    ExpandableFABView(
                        isExpanded: $expanded,
                        mainIcon: "plus",
                        items: [
                            ExpandableFABItem(icon: "square.and.arrow.up", label: "Share", action: {}),
                            ExpandableFABItem(icon: "heart.fill", label: "Like", action: {}),
                            ExpandableFABItem(icon: "star.fill", label: "Favorite", action: {})
                        ]
                    )
                }
        }
    }
    return PreviewWrapper()
}
