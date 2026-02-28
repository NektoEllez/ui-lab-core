//
//  PrimaryButtonStyle.swift
//  SwiftUiViews
//
//  Custom button style: press haptic, subtle scale/opacity (HIG, reduce motion–aware).
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundStyle(.background)
            .frame(maxWidth: .infinity, minHeight: 50)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .contentShape(.rect)
            .modifier(PrimaryButtonBackground(isPressed: configuration.isPressed))
            .managedButtonPress(
                isPressed: configuration.isPressed,
                spec: PrimaryConstants.interaction,
                reduceMotion: reduceMotion
            )
    }
}

/// Primary: тёмный фон — светлый текст, светлый фон — тёмный текст (без синего).
private struct PrimaryButtonBackground: ViewModifier {
    let isPressed: Bool

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.primary)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.white.opacity(isPressed ? 0.12 : 0))
            )
            .animation(PrimaryConstants.interaction.pressAnimation, value: isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.medium))
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, minHeight: 50)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .contentShape(.rect)
            .modifier(SecondaryButtonBackground(isPressed: configuration.isPressed))
            .managedButtonPress(
                isPressed: configuration.isPressed,
                spec: SecondaryConstants.interaction,
                reduceMotion: reduceMotion
            )
    }
}

/// Блюр для secondary: материал + обводка (не glass), визуально отличается от primary.
private struct SecondaryButtonBackground: ViewModifier {
    let isPressed: Bool

    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.thinMaterial)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(.secondary.opacity(0.6), lineWidth: 1.5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.black.opacity(isPressed ? 0.06 : 0))
            )
            .animation(SecondaryConstants.interaction.pressAnimation, value: isPressed)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondaryBordered: SecondaryButtonStyle { SecondaryButtonStyle() }
}

// MARK: - Primary: glass + accent, чуть больше bounce

private enum PrimaryConstants {
    static let interaction = ButtonInteractionSpec(
        pressedScale: 0.96,
        pressedOpacity: 0.92,
        pressAnimation: .spring(response: 0.28, dampingFraction: 0.72),
        feedback: .impactLight
    )
}

// MARK: - Secondary: blur (material), быстрый snappy без bounce

private enum SecondaryConstants {
    static let interaction = ButtonInteractionSpec(
        pressedScale: 0.97,
        pressedOpacity: 0.9,
        pressAnimation: .snappy(duration: 0.18),
        feedback: .selection
    )
}
