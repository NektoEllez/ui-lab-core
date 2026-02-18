//
//  MenuRowButtonStyle.swift
//  SwiftUiViews
//
//  Press animation + haptic for menu/settings rows (HIG, reduce motion–aware).
//

import SwiftUI

/// Button style for menu/settings list: лёгкий scale + хаптик при нажатии.
struct MenuRowButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .managedButtonPress(
                isPressed: configuration.isPressed,
                spec: Constants.interaction,
                reduceMotion: reduceMotion
            )
    }
}

private enum Constants {
    static let interaction = ButtonInteractionSpec(
        pressedScale: 0.985,
        pressedOpacity: 1,
        pressAnimation: .snappy(duration: 0.14),
        feedback: .selection
    )
}
