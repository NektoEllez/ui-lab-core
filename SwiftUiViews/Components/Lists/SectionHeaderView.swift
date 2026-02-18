//
//  SectionHeaderView.swift
//  SwiftUiViews
//
//  Custom section header for lists: title, optional action button.
//  Best practice: decomposed, semantic styling.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack {
            headerTitle
            Spacer(minLength: Constants.spacerMinLength)
            headerAction
        }
        .padding(.vertical, Constants.verticalPadding)
    }

    // MARK: - Private subviews

    private var headerTitle: some View {
        Text(title)
            .font(.headline.weight(.semibold))
            .foregroundStyle(.primary)
            .textCase(nil)
    }

    @ViewBuilder
    private var headerAction: some View {
        if let actionTitle, let action {
            Button(actionTitle, action: action)
                .font(.subheadline.weight(.medium))
                .tint(.accentColor)
        }
    }
}

// MARK: - Constants

private enum Constants {
    static let verticalPadding: CGFloat = 4
    static let spacerMinLength: CGFloat = 8
}

#Preview("SectionHeaderView") {
    List {
        Section {
            ForEach(0..<3) { _ in
                Text("Item")
            }
        } header: {
            SectionHeaderView(title: "Recent", actionTitle: "See All") {}
        }
    }
}
