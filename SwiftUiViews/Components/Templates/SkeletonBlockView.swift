//
//  SkeletonBlockView.swift
//  SwiftUiViews
//
//  Lightweight skeleton placeholder with shimmer-like highlight.
//

import SwiftUI

struct SkeletonBlockView: View {
    let cornerRadius: CGFloat
    let height: CGFloat

    @State private var animated = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(height: CGFloat = 14, cornerRadius: CGFloat = 8) {
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color.platformSecondaryFill)
            .overlay {
                if !reduceMotion {
                    shimmerMask
                        .mask(
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .fill(.white)
                        )
                }
            }
            .frame(height: height)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.linear(duration: 1.1).repeatForever(autoreverses: false)) {
                    animated = true
                }
            }
    }

    private var shimmerMask: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            LinearGradient(
                colors: [.clear, .white.opacity(0.55), .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: width * 0.45)
            .offset(x: animated ? width * 1.2 : -width * 0.6)
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        SkeletonBlockView(height: 18)
        SkeletonBlockView(height: 14)
        SkeletonBlockView(height: 14)
            .frame(maxWidth: 220)
    }
    .padding()
}
