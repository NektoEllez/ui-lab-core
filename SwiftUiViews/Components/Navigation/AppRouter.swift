//
//  AppRouter.swift
//  SwiftUiViews
//
//  Coordinator for app navigation: owns path and route→destination mapping.
//  Best practice: navigation logic separated from views, type-safe path.
//

import SwiftUI

@Observable
@MainActor
final class AppRouter {
    var path: [Route] = []

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    @ViewBuilder
    func destination(for route: Route) -> some View {
        switch route {
        case .buttons:
            ButtonsDemoView()
        case .textFields:
            TextFieldsDemoView()
        case .toast:
            EmptyView() // Built in ContentView with ToastDemoView(toastStore:)
        case .banners:
            BannersDemoView()
        case .lists:
            ListsDemoView()
        case .messageList:
            MessageListDemoView()
        case .bottomBar:
            BottomBarDemoView()
        case .chips:
            ChipsDemoView()
        case .templates:
            TemplatesDemoView()
        case .moreComponents:
            MoreComponentsDemoView()
        case .settings:
            SettingsDemoView()
        case .notifications:
            NotificationsDemoView()
        case .profile:
            ProfileDemoView()
        case .help:
            HelpDemoView()
        }
    }
}
