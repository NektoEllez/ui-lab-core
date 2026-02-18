//
//  NotificationsDemoView.swift
//  SwiftUiViews
//
//  Demo screen for notifications: toggle + recent list.
//

import SwiftUI

struct NotificationsDemoView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true

    var body: some View {
        notificationsList
            .navigationTitle("Notifications")
            .platformInlineTitleMode()
    }

    private var notificationsList: some View {
        List {
            preferencesSection
            recentSection
        }
        .platformInsetGroupedListStyle()
    }

    private var preferencesSection: some View {
        Section("Preferences") {
            Toggle(isOn: $notificationsEnabled) {
                Label("Push notifications", systemImage: "bell.badge")
            }
        }
    }

    private var recentSection: some View {
        Section("Recent") {
            ForEach(NotificationDemoItem.samples) { item in
                notificationRow(item)
            }
        }
    }

    private func notificationRow(_ item: NotificationDemoItem) -> some View {
        HStack(spacing: 12) {
            Image(systemName: item.icon)
                .font(.title3)
                .foregroundStyle(item.tintColor)
                .frame(width: 32, alignment: .center)
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.subheadline.weight(.medium))
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(item.timeAgo)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Demo model

private struct NotificationDemoItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let tintColor: Color
    let timeAgo: String

    static let samples: [NotificationDemoItem] = [
        NotificationDemoItem(
            id: "1",
            title: "New message",
            subtitle: "You have 3 unread messages",
            icon: "envelope.badge",
            tintColor: .accentColor,
            timeAgo: "2m ago"
        ),
        NotificationDemoItem(
            id: "2",
            title: "Reminder",
            subtitle: "Meeting in 15 minutes",
            icon: "calendar.badge.clock",
            tintColor: .orange,
            timeAgo: "1h ago"
        ),
        NotificationDemoItem(
            id: "3",
            title: "Update",
            subtitle: "App update available",
            icon: "arrow.down.circle",
            tintColor: .blue,
            timeAgo: "3h ago"
        ),
    ]
}

#Preview {
    NavigationStack {
        NotificationsDemoView()
    }
}
