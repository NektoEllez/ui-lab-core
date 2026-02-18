//
//  CardStyle.swift
//  SwiftUiViews
//
//  Simple card style: background + corner radius + optional shadow (no glass).
//

import SwiftUI

extension View {
    /// Карточный стиль: фон, скругление, опциональная тень (без glass).
    func cardStyle(
        cornerRadius: CGFloat = 16,
        backgroundColor: Color = Color.platformSecondarySystemBackground,
        shadowColor: Color = .black.opacity(0.08),
        shadowRadius: CGFloat = 8,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 4
    ) -> some View {
        self
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
    }
}

#Preview("Card style") {
    VStack(alignment: .leading, spacing: 8) {
        Text("Card title")
            .font(.headline)
        Text("Card content with shadow and rounded corners.")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(20)
    .cardStyle()
    .padding()
}
