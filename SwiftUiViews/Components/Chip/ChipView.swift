//
//  ChipView.swift
//  SwiftUiViews
//
//  Reusable pill (chip) for filters/tags. Selected vs unselected state.
//  Use with Button: Button { } label: { ChipView(title: "All", isSelected: ...) }
//

import SwiftUI

struct ChipView: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(isSelected ? .primary : .secondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.primary.opacity(0.12) : Color.secondary.opacity(0.08))
            )
    }
}

#Preview("Chips") {
    HStack(spacing: 10) {
        ChipView(title: "All", isSelected: true)
        ChipView(title: "Option", isSelected: false)
        ChipView(title: "Selected", isSelected: true)
    }
    .padding()
}
