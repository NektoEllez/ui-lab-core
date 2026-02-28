//
//  ComponentCatalog.swift
//  SwiftUiViews
//
//  Single source of truth for the components home screen structure.
//

import SwiftUI

struct ComponentCatalogSection: Identifiable {
    let id: String
    let title: String
    let items: [ComponentCatalogItem]
}

struct ComponentCatalogItem: Identifiable {
    let route: Route

    var id: String { route.rawValue }
    var title: String { route.title }
    var icon: String { route.icon }
}

enum ComponentCatalog {
    static let sections: [ComponentCatalogSection] = [
        ComponentCatalogSection(
            id: "core-components",
            title: "Core Components",
            items: [
                ComponentCatalogItem(route: .buttons),
                ComponentCatalogItem(route: .textFields),
                ComponentCatalogItem(route: .toast),
                ComponentCatalogItem(route: .banners),
                ComponentCatalogItem(route: .chips)
            ]
        ),
        ComponentCatalogSection(
            id: "navigation-lists",
            title: "Navigation & Lists",
            items: [
                ComponentCatalogItem(route: .lists),
                ComponentCatalogItem(route: .messageList),
                ComponentCatalogItem(route: .bottomBar)
            ]
        ),
        ComponentCatalogSection(
            id: "templates",
            title: "Template Kit",
            items: [
                ComponentCatalogItem(route: .templates)
            ]
        ),
        ComponentCatalogSection(
            id: "composed-screens",
            title: "Composed Screens",
            items: [
                ComponentCatalogItem(route: .moreComponents)
            ]
        )
    ]
}
