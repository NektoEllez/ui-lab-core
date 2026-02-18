//
//  MessageListDemoViewModel.swift
//  SwiftUiViews
//
//  MessageList feature — ViewModel: messages, search, filtered sections, CRUD.
//

import SwiftUI

@Observable
@MainActor
final class MessageListDemoViewModel {
    var messages: [MessageListItem] = []
    var searchQuery: String = ""

    private var normalizedQuery: String {
        searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isSearchActive: Bool {
        !normalizedQuery.isEmpty
    }

    var hasNoMessagesToShow: Bool {
        if isSearchActive {
            return filteredSearchResults.isEmpty
        }
        return filteredNewMessages.isEmpty && filteredReadMessages.isEmpty
    }

    var emptyStateMessage: String {
        if isSearchActive {
            if filteredSearchResults.isEmpty {
                return "По запросу «\(normalizedQuery)» ничего не найдено. Попробуйте другое имя или текст письма."
            }
            return "Попробуйте другой запрос."
        }
        return "You don't have any messages yet."
    }

    private func matchesSearch(_ message: MessageListItem) -> Bool {
        if normalizedQuery.isEmpty { return true }
        let q = normalizedQuery.lowercased()
        return message.sender.localizedStandardContains(q) || message.preview.localizedStandardContains(q)
    }

    var filteredSearchResults: [MessageListItem] {
        let new = messages.filter(\.isUnread).filter(matchesSearch)
        let read = messages.filter { !$0.isUnread }.filter(matchesSearch)
        return new + read
    }

    var searchResultsSnapshotId: String {
        "\(normalizedQuery)|\(filteredSearchResults.count)"
    }

    var filteredNewMessages: [MessageListItem] {
        messages.filter(\.isUnread).filter(matchesSearch)
    }

    var filteredReadMessages: [MessageListItem] {
        messages.filter { !$0.isUnread }.filter(matchesSearch)
    }

    init() {
        loadSample()
    }

    func refresh() async {
        do {
            try await Task.sleep(for: .seconds(0.8))
        } catch {
            return // Task cancelled
        }
        loadSample()
    }

    func markAsRead(_ message: MessageListItem) {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else { return }
        messages[index].isUnread = false
    }

    func deleteNew(at indexSet: IndexSet) {
        let newList = filteredNewMessages
        let idsToRemove = indexSet.map { newList[$0].id }
        withAnimation(Animations.listReordering) {
            messages.removeAll { idsToRemove.contains($0.id) }
        }
    }

    func deleteRead(at indexSet: IndexSet) {
        let readList = filteredReadMessages
        let idsToRemove = indexSet.map { readList[$0].id }
        withAnimation(Animations.listReordering) {
            messages.removeAll { idsToRemove.contains($0.id) }
        }
    }

    func deleteSearchResults(at indexSet: IndexSet) {
        let list = filteredSearchResults
        let idsToRemove = indexSet.map { list[$0].id }
        withAnimation(Animations.listReordering) {
            messages.removeAll { idsToRemove.contains($0.id) }
        }
    }

    func deleteMessage(_ message: MessageListItem) {
        withAnimation(Animations.listReordering) {
            messages.removeAll { $0.id == message.id }
        }
    }

    private func loadSample() {
        messages = [
            MessageListItem(
                sender: "Anna",
                preview: "Thanks for the update. I'll review it by tomorrow.",
                leadingImage: "person.circle.fill",
                timeAgo: "10:42",
                isUnread: true
            ),
            MessageListItem(
                sender: "Team",
                preview: "Meeting at 3 PM in Room B.",
                leadingImage: "person.3.fill",
                timeAgo: "Yesterday",
                isUnread: false
            ),
            MessageListItem(
                sender: "Support",
                preview: "Your ticket has been resolved.",
                leadingImage: "headphones",
                timeAgo: "Mon",
                isUnread: false
            ),
        ]
    }
}

private enum Animations {
    static let listReordering = Animation.spring(response: 0.52, dampingFraction: 0.86)
}
