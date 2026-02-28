//
//  LoadingOverlay.swift
//  SwiftUiViews
//
//  Full-screen loading overlay with ProgressView. Use when isLoading is true.
//

import SwiftUI

struct LoadingOverlay: ViewModifier {
    let isPresented: Bool
    let allowsHitTesting: Bool
    var backgroundColor: Color = .black.opacity(0.35)
    var progressTint: Color = .white

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    backgroundColor
                        .ignoresSafeArea()
                        .allowsHitTesting(allowsHitTesting)
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.2)
                        .tint(progressTint)
                        .allowsHitTesting(allowsHitTesting)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isPresented)
    }
}

extension View {
    /// Полноэкранный оверлей с индикатором загрузки при isPresented == true.
    func loadingOverlay(
        isPresented: Bool,
        allowsHitTesting: Bool = true,
        backgroundColor: Color = .black.opacity(0.35),
        progressTint: Color = .white
    ) -> some View {
        modifier(LoadingOverlay(
            isPresented: isPresented,
            allowsHitTesting: allowsHitTesting,
            backgroundColor: backgroundColor,
            progressTint: progressTint
        ))
    }
}

#Preview("Loading overlay") {
    struct PreviewWrapper: View {
        @State private var loading = true
        var body: some View {
            Color.platformSystemBackground
                .overlay(Text("Content"))
                .loadingOverlay(isPresented: loading)
                .onTapGesture { loading.toggle() }
        }
    }
    return PreviewWrapper()
}
