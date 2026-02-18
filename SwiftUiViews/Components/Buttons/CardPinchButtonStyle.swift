//
//  CardPinchButtonStyle.swift
//  SwiftUiViews
//
//  Button style: card look (background, shadow, corner radius) + "pinch" on press
//  (scale down, opacity). HIG-aligned, reduce motion–aware.
//  Use for card-like actions (e.g. from CourtAIApp / pf-ios design).
//

import SwiftUI

struct CardPinchButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var cornerRadius: CGFloat = 16
    var backgroundColor: Color = Color.platformSecondarySystemBackground

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.medium))
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .contentShape(.rect)
            .background(cardBackground(isPressed: configuration.isPressed))
            .managedButtonPress(
                isPressed: configuration.isPressed,
                spec: CardPinchConstants.interaction,
                reduceMotion: reduceMotion
            )
    }

    @ViewBuilder
    private func cardBackground(isPressed: Bool) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.regularMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(backgroundColor.opacity(0.4))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(.secondary.opacity(0.25), lineWidth: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.black.opacity(isPressed ? 0.05 : 0))
            )
            .shadow(
                color: .black.opacity(isPressed ? 0.05 : 0.08),
                radius: isPressed ? 3 : 6,
                x: 0,
                y: isPressed ? 1 : 3
            )
            .animation(CardPinchConstants.interaction.pressAnimation, value: isPressed)
    }
}

// MARK: - Card Pinch: материал + мягкая анимация «сжатия»

private enum CardPinchConstants {
    static let interaction = ButtonInteractionSpec(
        pressedScale: 0.98,
        pressedOpacity: 0.94,
        pressAnimation: .spring(response: 0.35, dampingFraction: 0.82),
        feedback: .impactLight
    )
}

extension ButtonStyle where Self == CardPinchButtonStyle {
    static var cardPinch: CardPinchButtonStyle { CardPinchButtonStyle() }

    static func cardPinch(
        cornerRadius: CGFloat = 16,
        backgroundColor: Color = Color.platformSecondarySystemBackground
    ) -> CardPinchButtonStyle {
        CardPinchButtonStyle(cornerRadius: cornerRadius, backgroundColor: backgroundColor)
    }
}

#Preview("Card Pinch") {
    VStack(spacing: 12) {
        Button("Card action") {}
            .buttonStyle(.cardPinch)
        Button("Another card", systemImage: "creditcard") {}
            .buttonStyle(.cardPinch)
    }
    .padding()
}
