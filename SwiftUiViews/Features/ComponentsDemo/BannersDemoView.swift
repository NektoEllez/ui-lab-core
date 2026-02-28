//
//  BannersDemoView.swift
//  SwiftUiViews
//
//  Demo: inline and overlay banners. Inline: same animation show/hide. Overlay: smooth banner, instant full-screen dimming.
//

import SwiftUI

struct BannersDemoView: View {
    @State private var bannerStore = BannerStore()
    @State private var inlineBanner: BannerItem?

    var body: some View {
        bannersList
            .navigationTitle("Banners")
            .platformInlineTitleMode()
            .overlay { bannerOverlay }
    }

    private var bannersList: some View {
        List {
            overlayBannerSection
            inlineBannerSection
        }
    }

    private var overlayBannerSection: some View {
        Section("Show overlay banner") {
            overlayInfoButton
            overlaySuccessButton
            overlayErrorButton
        }
    }

    private var overlayInfoButton: some View {
        Button("Info banner") {
            bannerStore.show(BannerItem(
                title: "Information",
                message: "This is an overlay banner with an optional action.",
                style: .info,
                actionTitle: "OK"
            ) { [weak bannerStore] in bannerStore?.dismiss() })
        }
    }

    private var overlaySuccessButton: some View {
        Button("Success banner") {
            bannerStore.show(BannerItem(
                title: "Success",
                message: "Your changes have been saved.",
                style: .success,
                actionTitle: "Dismiss"
            ) { [weak bannerStore] in bannerStore?.dismiss() })
        }
    }

    private var overlayErrorButton: some View {
        Button("Error banner") {
            bannerStore.show(BannerItem(
                title: "Error",
                message: "Something went wrong. Please try again.",
                style: .error,
                actionTitle: "Retry"
            ) { [weak bannerStore] in bannerStore?.dismiss() })
        }
    }

    @ViewBuilder
    private var inlineBannerSection: some View {
        Section("Inline banner") {
            if let item = inlineBanner {
                BannerView(item: item) {
                    withAnimation(Self.inlineBannerAnimation) { inlineBanner = nil }
                }
                .transition(Self.inlineBannerTransition)
            }
            inlineShowButton
        }
        .animation(Self.inlineBannerAnimation, value: inlineBanner?.title ?? "")
    }

    private var inlineShowButton: some View {
        Button("Show inline success") {
            withAnimation(Self.inlineBannerAnimation) {
                inlineBanner = BannerItem(
                    title: "Inline banner",
                    message: "This banner lives in the content flow.",
                    style: .success,
                    actionTitle: "Dismiss"
                ) { withAnimation(Self.inlineBannerAnimation) { inlineBanner = nil } }
            }
        }
        .disabled(inlineBanner != nil)
    }

    private var bannerOverlay: some View {
        ZStack(alignment: .top) {
            // Full-screen dimming: instant (no animation)
            Color.black.opacity(bannerStore.current != nil ? 0.4 : 0)
                .ignoresSafeArea()
                .animation(.linear(duration: 0), value: bannerStore.current != nil)

            // Banner content: smooth appearance
            if let item = bannerStore.current {
                BannerView(item: item) {
                    bannerStore.dismiss()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .transition(Self.overlayBannerTransition)
            }
            Spacer(minLength: 0)
        }
        .animation(Self.overlayBannerAnimation, value: bannerStore.current?.title ?? "")
    }
}

// MARK: - Inline: same animation for show and hide

private extension BannersDemoView {
    static let inlineBannerAnimation: Animation = .snappy(duration: 0.28)
    static var inlineBannerTransition: AnyTransition {
        .opacity.combined(with: .scale(scale: 0.98))
    }
}

// MARK: - Overlay: smooth banner, instant dimming

private extension BannersDemoView {
    static let overlayBannerAnimation: Animation = .spring(response: 0.45, dampingFraction: 0.85)
    static var overlayBannerTransition: AnyTransition {
        .move(edge: .top).combined(with: .opacity)
    }
}

#Preview {
    NavigationStack {
        BannersDemoView()
    }
}
