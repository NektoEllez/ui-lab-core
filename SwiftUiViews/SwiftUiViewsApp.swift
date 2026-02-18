//
//  SwiftUiViewsApp.swift
//  SwiftUiViews
//
//  Created by Nekto_Ellez on 02.02.2026.
//

import SwiftUI

@main
struct SwiftUiViewsApp: App {
    @State private var toastStore = ToastStore()
    @State private var appRouter = AppRouter()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appRouter)
                .environment(\.toastStore, toastStore)
                .toastOverlay(alignment: .top)
        }
    }
}
