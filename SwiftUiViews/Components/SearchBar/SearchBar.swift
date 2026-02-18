//
//  SearchBar.swift
//  SwiftUiViews
//
//  Compact search field: capsule background, magnifying glass, optional clear button.
//  Use @FocusState for keyboard dismiss; bind text and optional onSubmit/onClear.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search"
    var onSubmit: (() -> Void)?
    var onClear: (() -> Void)?
    /// Called when clear is tapped; use to dismiss keyboard, e.g. `onClearDismissFocus: { searchFocused = false }`.
    var onClearDismissFocus: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(.secondary)
                        .font(.body)
                }
                TextField("", text: $text)
                    #if os(iOS) || os(tvOS) || os(visionOS)
                    .textInputAutocapitalization(.never)
                    #endif
                    .disableAutocorrection(true)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .submitLabel(.search)
                    .onSubmit { onSubmit?() }
            }
            if !text.isEmpty {
                Button {
                    text = ""
                    onClear?()
                    onClearDismissFocus?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.platformSecondaryFill, in: Capsule())
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
    }
}

#Preview("SearchBar") {
    struct PreviewWrapper: View {
        @State private var query = ""
        @FocusState private var focused: Bool
        var body: some View {
            VStack {
                SearchBar(text: $query, onClearDismissFocus: { focused = false })
                SearchBar(text: .constant(""), placeholder: "Without focus dismiss")
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
