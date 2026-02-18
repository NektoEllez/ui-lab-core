//
//  SettingsDemoView.swift
//  SwiftUiViews
//
//  Typical settings: Appearance (Dark mode), Notifications, etc.
//  Tap from menu → navigate here (no merge animation).
//

import SwiftUI

struct SettingsDemoView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true

    var body: some View {
        settingsList
            .navigationTitle("Settings")
            .platformInlineTitleMode()
            .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    private var settingsList: some View {
        List {
            appearanceSection
            notificationsSection
        }
        .platformInsetGroupedListStyle()
    }

    private var appearanceSection: some View {
        Section("Appearance") {
            darkModeRow
        }
    }

    private var darkModeRow: some View {
        Toggle(isOn: $isDarkMode) {
            Label("Dark mode", systemImage: "moon.fill")
        }
    }

    private var notificationsSection: some View {
        Section("Notifications") {
            notificationsRow
        }
    }

    private var notificationsRow: some View {
        Toggle(isOn: $notificationsEnabled) {
            Label("Push notifications", systemImage: "bell.badge")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsDemoView()
    }
}
