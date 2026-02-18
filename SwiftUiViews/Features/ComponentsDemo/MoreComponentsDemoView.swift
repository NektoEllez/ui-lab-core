//
//  MoreComponentsDemoView.swift
//  SwiftUiViews
//
//  Demo: LoadingOverlay, CardStyle, SearchBar, HorizontalPagingScrollView + PageIndicatorView.
//

import SwiftUI

struct MoreComponentsDemoView: View {
    @State private var showLoading = false
    @State private var searchQuery = ""
    @FocusState private var searchFocused: Bool
    @State private var carouselIndex: Int? = 0

    private let carouselColors: [Color] = [.red.opacity(0.5), .blue.opacity(0.5), .green.opacity(0.5)]

    var body: some View {
        List {
            loadingOverlaySection
            cardStyleSection
            searchBarSection
            carouselSection
        }
        .navigationTitle("Overlay, card & search")
        .platformInlineTitleMode()
        .loadingOverlay(isPresented: showLoading)
    }

    private var loadingOverlaySection: some View {
        Section {
            Button(showLoading ? "Hide loading overlay" : "Show loading overlay") {
                showLoading.toggle()
            }
            .buttonStyle(.bordered)
        } header: {
            Text("Loading overlay")
        } footer: {
            Text(".loadingOverlay(isPresented:) — full-screen overlay with ProgressView.")
        }
    }

    private var cardStyleSection: some View {
        Section("Card style") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Card title")
                    .font(.headline)
                Text("Plain card with shadow and rounded corners (no glass).")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .cardStyle()
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowBackground(Color.clear)
        }
    }

    private var searchBarSection: some View {
        Section("Search bar") {
            SearchBar(
                text: $searchQuery,
                placeholder: "Search…",
                onClearDismissFocus: { searchFocused = false }
            )
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowBackground(Color.clear)
        }
    }

    @ViewBuilder
    private var carouselSection: some View {
        Section {
            if #available(iOS 17.0, *) {
                VStack(spacing: 12) {
                    HorizontalPagingScrollView(
                        pageCount: carouselColors.count,
                        selectedIndex: $carouselIndex,
                        cardWidthRatio: 0.85,
                        pinchScale: 0.92,
                        content: carouselCardContent
                    )
                    .frame(height: 160)
                    PageIndicatorView(count: carouselColors.count, selectedIndex: $carouselIndex)
                }
                .padding(.vertical, 0)
            } else {
                Text("Horizontal paging requires iOS 17.")
                    .foregroundStyle(.secondary)
            }
        } header: {
            Text("Horizontal paging")
        } footer: {
            Text("Peek: left/right cards visible. Pinch: non‑centered cards scaled down (cardWidthRatio 0.85, pinchScale 0.92).")
        }
    }

    @ViewBuilder
    private func carouselCardContent(index: Int) -> some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(carouselColors[index])
            .overlay(
                Text("Page \(index + 1)")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
            )
    }
}

#Preview {
    NavigationStack {
        MoreComponentsDemoView()
    }
}
