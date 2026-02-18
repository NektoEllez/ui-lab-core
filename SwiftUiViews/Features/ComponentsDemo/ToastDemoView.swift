//
//  ToastDemoView.swift
//  SwiftUiViews
//
//  Empty page: on appear a random toast is shown (no buttons, no navigation to toast view).
//  DI: toastStore passed explicitly so toasts show reliably when pushed.
//

import SwiftUI

struct ToastDemoView: View {
    let toastStore: ToastStore

    var body: some View {
        Color.clear
            .contentShape(.rect)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Toast")
            .platformInlineTitleMode()
            .task { await showRandomToast() }
    }

    private func showRandomToast() async {
        do {
            try await Task.sleep(for: .milliseconds(250))
        } catch {
            return // Task cancelled or sleep interrupted
        }
        let message = Self.randomToastMessages.randomElement() ?? Self.randomToastMessages[0]
        toastStore.show(message)
    }

    private static let randomToastMessages: [ToastMessage] = [
        ToastMessage(text: "Something happened.", icon: "info.circle"),
        ToastMessage(text: "Saved successfully.", icon: "checkmark.circle", style: .success),
        ToastMessage(text: "Please check your input.", icon: "exclamationmark.triangle", style: .warning),
        ToastMessage(text: "Something went wrong.", icon: "xmark.circle", style: .error),
        ToastMessage(text: "Done.", icon: "checkmark"),
        ToastMessage(text: "Copied to clipboard.", icon: "doc.on.doc"),
        ToastMessage(text: "Connection restored.", icon: "wifi", style: .success),
    ]
}

#Preview {
    let toastStore = ToastStore()
    return NavigationStack {
        ToastDemoView(toastStore: toastStore)
            .toastOverlay(alignment: .top)
    }
}
