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
    let id: String
    let route: Route
    let title: String
    let icon: String
}

enum ComponentCatalog {
    static let sections: [ComponentCatalogSection] = [
        ComponentCatalogSection(
            id: "core-components",
            title: "Core Components",
            items: [
                ComponentCatalogItem(id: "buttons", route: .buttons, title: "Buttons", icon: "hand.tap"),
                ComponentCatalogItem(id: "text-fields", route: .textFields, title: "Text fields", icon: "textformat"),
                ComponentCatalogItem(id: "toast", route: .toast, title: "Toast", icon: "bell.badge"),
                ComponentCatalogItem(id: "banners", route: .banners, title: "Banners", icon: "rectangle.portrait.topthird.inset.filled"),
                ComponentCatalogItem(id: "chips", route: .chips, title: "Chips", icon: "circle.grid.2x2")
            ]
        ),
        ComponentCatalogSection(
            id: "navigation-lists",
            title: "Navigation & Lists",
            items: [
                ComponentCatalogItem(id: "lists", route: .lists, title: "Lists (menu)", icon: "list.bullet"),
                ComponentCatalogItem(id: "message-list", route: .messageList, title: "Message list", icon: "envelope"),
                ComponentCatalogItem(id: "bottom-bar", route: .bottomBar, title: "Bottom bar / Footer", icon: "rectangle.bottomhalf.inset.filled")
            ]
        ),
        ComponentCatalogSection(
            id: "templates",
            title: "Template Kit",
            items: [
                ComponentCatalogItem(id: "templates-demo", route: .templates, title: "Templates & Scaffolds", icon: "square.grid.3x3.topleft.filled")
            ]
        ),
        ComponentCatalogSection(
            id: "composed-screens",
            title: "Composed Screens",
            items: [
                ComponentCatalogItem(id: "more-components", route: .moreComponents, title: "Overlay, card & search", icon: "square.stack.3d.up")
            ]
        )
    ]
}
