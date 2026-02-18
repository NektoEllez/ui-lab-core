//
//  BadgeView.swift
//  SwiftUiViews
//
//  Compact status badge for labels like New, Pro, Beta, Error.
//

import SwiftUI

struct BadgeView: View {
    enum Tone {
        case neutral
        case success
        case warning
        case danger
        case info

        var foreground: Color {
            switch self {
            case .neutral: .primary
            case .success: .green
            case .warning: .orange
            case .danger: .red
            case .info: .blue
            }
        }

        var background: Color {
            switch self {
            case .neutral: Color.platformSecondaryFill
            case .success: .green.opacity(0.16)
            case .warning: .orange.opacity(0.16)
            case .danger: .red.opacity(0.16)
            case .info: .blue.opacity(0.16)
            }
        }
    }

    let text: String
    let tone: Tone

    init(_ text: String, tone: Tone = .neutral) {
        self.text = text
        self.tone = tone
    }

    var body: some View {
        Text(text.uppercased())
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(tone.foreground)
            .background(
                Capsule(style: .continuous)
                    .fill(tone.background)
            )
            .accessibilityLabel("Badge \(text)")
    }
}

#Preview {
    HStack(spacing: 8) {
        BadgeView("New")
        BadgeView("Pro", tone: .info)
        BadgeView("Success", tone: .success)
        BadgeView("Warning", tone: .warning)
        BadgeView("Error", tone: .danger)
    }
    .padding()
}
