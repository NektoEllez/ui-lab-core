//
//  MessageListDemoView.swift
//  SwiftUiViews
//
//  MessageList feature — View: list with New/Read sections, search, centered banner.
//

import SwiftUI

struct MessageListDemoView: View {
    @State private var viewModel: MessageListDemoViewModel
    @Bindable private var bindableViewModel: MessageListDemoViewModel
    @State private var lastMarkedReadId: String?
    @State private var bannerMessage: MessageListItem?

    init() {
        let vm = MessageListDemoViewModel()
        _viewModel = State(initialValue: vm)
        _bindableViewModel = Bindable(vm)
    }

    var body: some View {
        contentView
            .overlay { messageBannerOverlay }
            .navigationTitle("Messages")
            .platformInlineTitleMode()
            .searchable(text: $bindableViewModel.searchQuery, prompt: "Search messages")
            .refreshable { await viewModel.refresh() }
            .toolbar { messageToolbar }
            .sensoryFeedback(.selection, trigger: lastMarkedReadId)
    }

    @ToolbarContentBuilder
    private var messageToolbar: some ToolbarContent {
        #if os(macOS)
        ToolbarItem(placement: .automatic) {
            Button {
                // Notifications / filter
            } label: {
                Image(systemName: "bell.badge")
            }
        }
        #else
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                // Notifications / filter
            } label: {
                Image(systemName: "bell.badge")
            }
        }
        #endif
    }

    // MARK: - Private subviews

    @ViewBuilder
    private var contentView: some View {
        Group {
            if viewModel.hasNoMessagesToShow {
                emptyStateView
                    .transition(Animations.contentTransition)
            } else {
                messageList
                    .transition(Animations.contentTransition)
            }
        }
        .animation(Animations.searchContent, value: viewModel.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines))
        .animation(Animations.searchContent, value: viewModel.hasNoMessagesToShow)
    }

    private var emptyStateView: some View {
        EmptyStateView(
            icon: viewModel.isSearchActive ? "magnifyingglass" : "envelope.open",
            title: viewModel.isSearchActive ? "Ничего не найдено" : "No Messages",
            message: viewModel.emptyStateMessage,
            actionTitle: nil
        )
    }

    private var messageList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ListDesign.sectionSpacing) {
                if viewModel.isSearchActive {
                    searchResultsCard
                } else {
                    newMessagesCard
                    readMessagesCard
                }
            }
            .padding(.horizontal, ListDesign.horizontalPadding)
            .padding(.bottom, ListDesign.bottomPadding)
        }
        .background(Color.platformGroupedBackground)
        .animation(Animations.listReordering, value: viewModel.searchResultsSnapshotId)
    }

    @ViewBuilder
    private var searchResultsCard: some View {
        if !viewModel.filteredSearchResults.isEmpty {
            cardSection(title: "Результаты поиска", messages: viewModel.filteredSearchResults)
                .transition(Animations.searchSectionTransition)
        }
    }

    @ViewBuilder
    private var newMessagesCard: some View {
        if !viewModel.filteredNewMessages.isEmpty {
            cardSection(title: "Новые сообщения", messages: viewModel.filteredNewMessages)
                .transition(Animations.searchSectionTransition)
        }
    }

    @ViewBuilder
    private var readMessagesCard: some View {
        if !viewModel.filteredReadMessages.isEmpty {
            cardSection(title: "Прочитанные", messages: viewModel.filteredReadMessages)
                .transition(Animations.searchSectionTransition)
        }
    }

    private func cardSection(title: String, messages: [MessageListItem]) -> some View {
        VStack(alignment: .leading, spacing: ListDesign.headerToCardSpacing) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
            cardContainer(messages: messages)
        }
    }

    private func cardContainer(messages: [MessageListItem]) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(messages.enumerated()), id: \.element.id) { index, message in
                messageRow(for: message)
                    .contextMenu {
                        Button(role: .destructive) {
                            viewModel.deleteMessage(message)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                if index < messages.count - 1 {
                    Divider()
                        .padding(.leading, ListDesign.leadingSize + ListDesign.contentSpacing)
                }
            }
        }
        .padding(.horizontal, ListDesign.cardInnerPadding)
        .background(Color.platformSystemBackground)
        .clipShape(RoundedRectangle(cornerRadius: ListDesign.cardCornerRadius, style: .continuous))
        .shadow(color: ListDesign.shadowColor, radius: ListDesign.shadowRadius, x: 0, y: ListDesign.shadowY)
    }

    private enum ListDesign {
        static let sectionSpacing: CGFloat = 24
        static let headerToCardSpacing: CGFloat = 10
        static let horizontalPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 24
        static let cardInnerPadding: CGFloat = 16
        static let cardCornerRadius: CGFloat = 12
        static let leadingSize: CGFloat = 40
        static let contentSpacing: CGFloat = 12
        static let shadowColor = Color.black.opacity(0.08)
        static let shadowRadius: CGFloat = 8
        static let shadowY: CGFloat = 4
    }

    private func messageRow(for message: MessageListItem) -> some View {
        MessageListRow(
            title: message.sender,
            preview: message.preview,
            leadingImage: message.leadingImage,
            trailingText: message.timeAgo,
            isUnread: message.isUnread,
            action: {
                lastMarkedReadId = message.id
                withAnimation(Animations.bannerAppear) {
                    bannerMessage = message
                }
            }
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                viewModel.deleteMessage(message)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    @ViewBuilder
    private var messageBannerOverlay: some View {
        if let message = bannerMessage {
            MessageBannerView(
                sender: message.sender,
                preview: message.preview,
                leadingImage: message.leadingImage,
                onDismiss: dismissBannerAndMarkRead(message)
            )
            .transition(Animations.bannerTransition)
            .zIndex(1)
            .task(id: message.id) {
                do {
                    try await Task.sleep(for: .seconds(2.5))
                    await MainActor.run { dismissBannerAndMarkRead(message)() }
                } catch {}
            }
        }
    }

    private func dismissBannerAndMarkRead(_ message: MessageListItem) -> () -> Void {
        return {
            withAnimation(Animations.bannerDismiss) {
                bannerMessage = nil
                viewModel.markAsRead(message)
            }
        }
    }

    // MARK: - View animation constants

    enum Animations {
        static let bannerAppear = Animation.spring(response: 0.5, dampingFraction: 0.82)
        static let bannerDismiss = Animation.spring(response: 0.42, dampingFraction: 0.9)
        static let listReordering = Animation.spring(response: 0.52, dampingFraction: 0.86)
        static let searchContent = Animation.spring(response: 0.45, dampingFraction: 0.88)

        static var bannerTransition: AnyTransition {
            .asymmetric(
                insertion: .opacity.combined(with: .scale(scale: 0.92)),
                removal: .opacity.combined(with: .scale(scale: 0.96))
            )
        }

        static var searchSectionTransition: AnyTransition {
            .asymmetric(
                insertion: .opacity.combined(with: .move(edge: .top)),
                removal: .opacity.combined(with: .move(edge: .top))
            )
        }

        static var contentTransition: AnyTransition {
            .opacity.combined(with: .scale(scale: 0.98))
        }
    }
}

// MARK: - Centered message banner (view-only)

private struct MessageBannerView: View {
    let sender: String
    let preview: String
    let leadingImage: String
    let onDismiss: () -> Void

    var body: some View {
        Color.black.opacity(0.35)
            .ignoresSafeArea()
            .onTapGesture { onDismiss() }
            .overlay {
                bannerCard
            }
    }

    private var bannerCard: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: leadingImage)
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text(sender)
                    .font(.headline)
                Text(preview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: 320)
        .glassStyleBackground(cornerRadius: 12)
        .padding(.horizontal, 24)
        .onTapGesture { onDismiss() }
    }
}

#Preview {
    NavigationStack {
        MessageListDemoView()
    }
}
