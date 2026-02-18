//
//  HorizontalPagingScrollView.swift
//  SwiftUiViews
//
//  Horizontal paging: snap by index, selectedIndex bound to scroll position.
//  Optional pinch (cardWidthRatio < 1): peek left/right + scale. iOS 17+.
//

import SwiftUI

@available(iOS 17.0, *)
struct HorizontalPagingScrollView<Content: View>: View {
    let pageCount: Int
    @Binding var selectedIndex: Int?
    var horizontalPadding: CGFloat = 0
    /// Card width as fraction of container (1 = full width). Use 0.85 for peek left/right + pinch.
    var cardWidthRatio: CGFloat = 1.0
    /// Scale for non‑centered cards (pinch). Used when cardWidthRatio < 1.
    var pinchScale: CGFloat = 0.92
    @ViewBuilder let content: (Int) -> Content

    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width - horizontalPadding * 2
            let cardWidth = containerWidth * cardWidthRatio
            let sidePeek = (containerWidth - cardWidth) / 2

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(0..<pageCount, id: \.self) { index in
                        cardView(index: index, cardWidth: cardWidth, height: geometry.size.height)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, horizontalPadding + sidePeek)
            }
            .scrollPosition(id: $selectedIndex)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        }
    }

    @ViewBuilder
    private func cardView(index: Int, cardWidth: CGFloat, height: CGFloat) -> some View {
        let card = content(index)
            .frame(width: cardWidth, height: height)
            .id(index)
        if cardWidthRatio < 1 {
            card
                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                    view.scaleEffect(phase.isIdentity ? 1 : pinchScale)
                }
        } else {
            card
        }
    }
}

@available(iOS 17.0, *)
#Preview("Horizontal paging") {
    struct PreviewWrapper: View {
        @State private var index: Int? = 0
        var body: some View {
            VStack(spacing: 16) {
                HorizontalPagingScrollView(pageCount: 3, selectedIndex: $index) { i in
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill([Color.red, .blue, .green][i].opacity(0.6))
                        .overlay(Text("Page \(i + 1)"))
                }
                .frame(height: 180)
                PageIndicatorView(count: 3, selectedIndex: $index)
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
