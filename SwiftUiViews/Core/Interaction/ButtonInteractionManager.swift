//
//  ButtonInteractionManager.swift
//  SwiftUiViews
//
//  Centralized button interaction rules: press animation, haptic feedback, tap throttling.
//

import SwiftUI

enum ButtonFeedbackKind {
    case none
    case selection
    case impactLight
    case impactMedium

    var sensoryFeedback: SensoryFeedback? {
        switch self {
        case .none:
            nil
        case .selection:
            .selection
        case .impactLight:
            .impact(weight: .light)
        case .impactMedium:
            .impact(weight: .medium)
        }
    }
}

struct ButtonInteractionSpec {
    let pressedScale: CGFloat
    let pressedOpacity: Double
    let pressAnimation: Animation
    let feedback: ButtonFeedbackKind
}

@MainActor
final class ButtonTapManager {
    static let shared = ButtonTapManager()
    private var lastTapDateByID: [String: Date] = [:]

    private init() {}

    func shouldHandleTap(id: String, minimumInterval: TimeInterval = 0.12) -> Bool {
        let now = Date()
        if let previous = lastTapDateByID[id], now.timeIntervalSince(previous) < minimumInterval {
            return false
        }
        lastTapDateByID[id] = now
        return true
    }
}

extension View {
    func managedButtonPress(
        isPressed: Bool,
        spec: ButtonInteractionSpec,
        reduceMotion: Bool
    ) -> some View {
        self
            .opacity(isPressed ? spec.pressedOpacity : 1)
            .scaleEffect(reduceMotion ? 1 : (isPressed ? spec.pressedScale : 1))
            .animation(spec.pressAnimation, value: isPressed)
            .sensoryFeedback(trigger: isPressed) { _, newValue in
                guard newValue else { return nil }
                return spec.feedback.sensoryFeedback
            }
    }
}
