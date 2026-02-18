//
//  PageIndicatorView.swift
//  SwiftUiViews
//
//  Dots indicator for horizontal paging / carousel. Selected index highlighted.
//

import SwiftUI

struct PageIndicatorView: View {
    let count: Int
    @Binding var selectedIndex: Int?

    private var current: Int {
        min(max(selectedIndex ?? 0, 0), max(count - 1, 0))
    }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index == current ? Color.accentColor : Color.secondary.opacity(0.35))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

#Preview("Page indicator") {
    VStack(spacing: 20) {
        PageIndicatorView(count: 5, selectedIndex: .constant(0))
        PageIndicatorView(count: 3, selectedIndex: .constant(2))
    }
}
