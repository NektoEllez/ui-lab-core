//
//  AsyncImageCardView.swift
//  SwiftUiViews
//
//  Card with async image loading states and retry.
//

import SwiftUI

struct AsyncImageCardView: View {
    let url: URL?
    let title: String
    let subtitle: String
    let cornerRadius: CGFloat

    @State private var reloadToken = UUID()

    init(
        url: URL?,
        title: String,
        subtitle: String,
        cornerRadius: CGFloat = 14
    ) {
        self.url = url
        self.title = title
        self.subtitle = subtitle
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: url, transaction: Transaction(animation: .easeInOut(duration: 0.22))) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle().fill(.secondary.opacity(0.12))
                        ProgressView()
                    }
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    ZStack {
                        Rectangle().fill(.secondary.opacity(0.12))
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .foregroundStyle(.secondary)
                            Button("Retry") {
                                reloadToken = UUID()
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                    }
                @unknown default:
                    Rectangle().fill(.secondary.opacity(0.12))
                }
            }
            .id(reloadToken)
            .frame(height: 140)
            .clipped()
            .clipShape(.rect(cornerRadius: cornerRadius))

            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.thinMaterial)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview("Async Image Card") {
    AsyncImageCardView(
        url: URL(string: "https://picsum.photos/400/220"),
        title: "Async image card",
        subtitle: "Network image with loading and retry states"
    )
    .padding()
}
