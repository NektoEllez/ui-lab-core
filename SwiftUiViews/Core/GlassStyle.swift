//
//  GlassStyle.swift
//  SwiftUiViews
//
//  Стеклянный стиль (Liquid Glass) на iOS 26+; fallthrough на .regularMaterial при версии ниже 26.
//

import SwiftUI

// MARK: - View + glass style background

extension View {
    /// Стеклянный фон: на iOS 26+ — glassEffect(in:), при версии ниже 26 — .regularMaterial (fallthrough).
    @ViewBuilder
    func glassStyleBackground(cornerRadius: CGFloat = 12) -> some View {
        if #available(iOS 26, *) {
            self
                .glassEffect(in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }

    /// Стеклянный стиль для бара (footer/toolbar): iOS 26+ — glassEffect(), иначе — .bar (fallthrough).
    @ViewBuilder
    func glassStyleBar() -> some View {
        if #available(iOS 26, *) {
            self
                .glassEffect()
        } else {
            self
                .background(.bar)
        }
    }
}
