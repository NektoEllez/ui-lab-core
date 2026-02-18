//
//  MenuItem.swift
//  SwiftUiViews
//
//  Lists feature — model: static menu row (title, subtitle, icon, route).
//

import SwiftUI

struct MenuItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let tintColor: Color
    let route: Route

    static let favorites: [MenuItem] = [
        MenuItem(
            id: "notifications",
            title: "Notifications",
            subtitle: "5 new",
            icon: "bell",
            tintColor: .orange,
            route: .notifications
        ),
        MenuItem(
            id: "messages",
            title: "Messages",
            subtitle: "3 unread",
            icon: "envelope",
            tintColor: .accentColor,
            route: .messageList
        ),
    ]

    static let recent: [MenuItem] = [
        MenuItem(
            id: "settings",
            title: "Settings",
            subtitle: "Manage preferences",
            icon: "gearshape",
            tintColor: .accentColor,
            route: .settings
        ),
        MenuItem(
            id: "profile",
            title: "Profile",
            subtitle: "View profile",
            icon: "person.circle",
            tintColor: .accentColor,
            route: .profile
        ),
        MenuItem(
            id: "help",
            title: "Help",
            subtitle: "Get support",
            icon: "questionmark.circle",
            tintColor: .accentColor,
            route: .help
        ),
    ]
}
