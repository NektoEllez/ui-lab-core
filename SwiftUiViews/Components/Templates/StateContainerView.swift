//
//  StateContainerView.swift
//  SwiftUiViews
//
//  Standardized state wrapper for loading/empty/error/content.
//

import SwiftUI

enum StateContainerPhase: Equatable {
    case loading
    case empty(title: String, message: String)
    case error(message: String)
    case content
}

struct StateContainerView<Content: View>: View {
    let phase: StateContainerPhase
    let retryAction: (() -> Void)?
    @ViewBuilder let content: () -> Content

    init(
        phase: StateContainerPhase,
        retryAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.phase = phase
        self.retryAction = retryAction
        self.content = content
    }

    var body: some View {
        switch phase {
        case .loading:
            VStack(spacing: 12) {
                ProgressView()
                Text("Loading...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, minHeight: 120)
        case let .empty(title, message):
            VStack(spacing: 8) {
                Image(systemName: "tray")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .padding(.horizontal, 12)
        case let .error(message):
            VStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.title3)
                    .foregroundStyle(.orange)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                if let retryAction {
                    Button("Try again", action: retryAction)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .padding(.horizontal, 12)
        case .content:
            content()
        }
    }
}

#Preview("State Container") {
    VStack(spacing: 12) {
        StateContainerView(phase: .loading) {
            EmptyView()
        }
        StateContainerView(phase: .empty(title: "No items", message: "Create your first item to get started.")) {
            EmptyView()
        }
        StateContainerView(phase: .error(message: "Unable to load data"), retryAction: {}) {
            EmptyView()
        }
    }
    .padding()
}
