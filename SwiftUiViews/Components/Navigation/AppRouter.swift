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
    func destination(for route: Route, toastStore: ToastStore?) -> some View {
        route.destination(toastStore: toastStore)
    }
}
