//
//  ListsDemoView.swift
//  SwiftUiViews
//
//  Lists feature — View: static menu list (Favorites, Recent), tap = push route.
//

import SwiftUI

struct ListsDemoView: View {
    @Environment(AppRouter.self) private var router
    @State private var lastTappedId: String?

    var body: some View {
        menuList
            .navigationTitle("Lists")
            .platformInlineTitleMode()
            .sensoryFeedback(.selection, trigger: lastTappedId)
    }

    // MARK: - Private subviews

    private var menuList: some View {
        List {
            favoriteSection
            recentSection
        }
        .platformInsetGroupedListStyle()
    }

    private var favoriteSection: some View {
        Section {
            ForEach(MenuItem.favorites) { item in
                menuRow(for: item)
            }
        } header: {
            SectionHeaderView(title: "Favorites")
        }
    }

    private var recentSection: some View {
        Section {
            ForEach(MenuItem.recent) { item in
                menuRow(for: item)
            }
        } header: {
            SectionHeaderView(title: "Recent")
        }
    }

    private func menuRow(for item: MenuItem) -> some View {
        ListRow(
            icon: item.icon,
            title: item.title,
            subtitle: item.subtitle,
            tintColor: item.tintColor
        ) {
            router.push(item.route)
            lastTappedId = item.id
        }
    }
}

#Preview {
    NavigationStack {
        ListsDemoView()
            .environment(AppRouter())
    }
}
