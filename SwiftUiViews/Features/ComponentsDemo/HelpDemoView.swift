//
//  HelpDemoView.swift
//  SwiftUiViews
//
//  Help: FAQ, Contact support. Tap from menu → navigate here.
//

import SwiftUI

struct HelpDemoView: View {
    var body: some View {
        helpList
            .navigationTitle("Help")
            .platformInlineTitleMode()
    }

    private var helpList: some View {
        List {
            faqSection
            supportSection
        }
        .platformInsetGroupedListStyle()
    }

    private var faqSection: some View {
        Section("FAQ") {
            if let url = URL(string: "https://example.com/faq") {
                Link(destination: url) {
                    Label("Frequently asked questions", systemImage: "questionmark.circle")
                }
            }
        }
    }

    private var supportSection: some View {
        Section("Support") {
            Button {
                // Contact action
            } label: {
                Label("Contact support", systemImage: "envelope")
            }
        }
    }
}

#Preview {
    NavigationStack {
        HelpDemoView()
    }
}
