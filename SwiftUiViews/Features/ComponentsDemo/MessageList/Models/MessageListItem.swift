//
//  MessageListItem.swift
//  SwiftUiViews
//
//  MessageList feature — model: one message row (sender, preview, read state).
//

import Foundation

struct MessageListItem: Identifiable {
    let id: String
    let sender: String
    let preview: String
    let leadingImage: String
    let timeAgo: String
    var isUnread: Bool

    init(
        sender: String,
        preview: String,
        leadingImage: String,
        timeAgo: String,
        isUnread: Bool = false
    ) {
        self.id = UUID().uuidString
        self.sender = sender
        self.preview = preview
        self.leadingImage = leadingImage
        self.timeAgo = timeAgo
        self.isUnread = isUnread
    }
}
