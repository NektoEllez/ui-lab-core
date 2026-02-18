//
//  AvatarView.swift
//  SwiftUiViews
//
//  Reusable avatar with image/initials fallback and online indicator.
//

import SwiftUI

struct AvatarView: View {
    enum Presence {
        case none
        case online
        case offline

        var color: Color {
            switch self {
            case .none: .clear
            case .online: .green
            case .offline: .gray
            }
        }
    }

    let initials: String
    let image: Image?
    let size: CGFloat
    let presence: Presence

    init(
        initials: String,
        image: Image? = nil,
        size: CGFloat = 44,
        presence: Presence = .none
    ) {
        self.initials = initials
        self.image = image
        self.size = size
        self.presence = presence
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarContent
                .frame(width: size, height: size)
                .clipShape(Circle())

            if presence != .none {
                Circle()
                    .fill(presence.color)
                    .frame(width: max(10, size * 0.26), height: max(10, size * 0.26))
                    .overlay(Circle().stroke(.background, lineWidth: 2))
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Avatar \(initials)")
    }

    @ViewBuilder
    private var avatarContent: some View {
        if let image {
            image
                .resizable()
                .scaledToFill()
        } else {
            Circle()
                .fill(.thinMaterial)
                .overlay {
                    Text(initials)
                        .font(.system(size: size * 0.34, weight: .semibold))
                        .foregroundStyle(.primary)
                }
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        AvatarView(initials: "AN")
        AvatarView(initials: "UI", size: 52, presence: .online)
        AvatarView(initials: "DB", size: 60, presence: .offline)
    }
    .padding()
}
