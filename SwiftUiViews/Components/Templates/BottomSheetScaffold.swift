//
//  BottomSheetScaffold.swift
//  SwiftUiViews
//
//  Reusable scaffold to present bottom sheets with common defaults.
//

import SwiftUI

struct BottomSheetScaffold<Content: View, SheetContent: View>: View {
    @Binding var isPresented: Bool
    let detents: [PresentationDetent]
    let content: Content
    let sheetContent: SheetContent

    init(
        isPresented: Binding<Bool>,
        detents: [PresentationDetent] = [.medium, .large],
        @ViewBuilder content: () -> Content,
        @ViewBuilder sheetContent: () -> SheetContent
    ) {
        self._isPresented = isPresented
        self.detents = detents
        self.content = content()
        self.sheetContent = sheetContent()
    }

    var body: some View {
        content
            .sheet(isPresented: $isPresented) {
                sheetContent
                    .presentationDetents(Set(detents))
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(20)
            }
    }
}

extension View {
    func bottomSheetScaffold<SheetContent: View>(
        isPresented: Binding<Bool>,
        detents: [PresentationDetent] = [.medium, .large],
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        BottomSheetScaffold(isPresented: isPresented, detents: detents) {
            self
        } sheetContent: {
            content()
        }
    }
}

#Preview("Bottom Sheet Scaffold") {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var showSheet = false

    var body: some View {
        Button("Open sheet") {
            showSheet = true
        }
        .buttonStyle(.borderedProminent)
        .bottomSheetScaffold(isPresented: $showSheet) {
            VStack(spacing: 12) {
                Text("Bottom Sheet")
                    .font(.headline)
                Text("Reusable scaffold with default detents.")
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .padding()
    }
}
