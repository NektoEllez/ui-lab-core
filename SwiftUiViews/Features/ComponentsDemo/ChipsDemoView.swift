//
//  ChipsDemoView.swift
//  SwiftUiViews
//
//  Demo: Chip — single-select (filters) and multi-select (tags). Page indicator is in Overlay, card & search.
//

import SwiftUI

struct ChipsDemoView: View {
    @State private var selectedFilter: String = "All"
    @State private var selectedTags: Set<String> = []

    private let filters = ["All", "Popular", "New", "For Her", "For Him"]
    private let tagOptions = ["Sale", "New", "Eco", "Premium", "Limited"]

    var body: some View {
        List {
            filterChipsSection
            multiSelectTagsSection
        }
        .navigationTitle("Chips")
        .platformInlineTitleMode()
    }

    private var filterChipsSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(filters, id: \.self) { filter in
                        Button {
                            selectedFilter = filter
                        } label: {
                            ChipView(title: filter, isSelected: selectedFilter == filter)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            .listRowBackground(Color.clear)
        } header: {
            Text("Single-select (filters)")
        } footer: {
            Text("One chip selected. Use with Button.")
        }
    }

    private var multiSelectTagsSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(tagOptions, id: \.self) { tag in
                        Button {
                            if selectedTags.contains(tag) {
                                selectedTags.remove(tag)
                            } else {
                                selectedTags.insert(tag)
                            }
                        } label: {
                            ChipView(title: tag, isSelected: selectedTags.contains(tag))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            .listRowBackground(Color.clear)
            if !selectedTags.isEmpty {
                Text("Selected: \(selectedTags.sorted().joined(separator: ", "))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } header: {
            Text("Multi-select (tags)")
        } footer: {
            Text("Tap to toggle. Several chips can be selected.")
        }
    }
}

#Preview {
    NavigationStack {
        ChipsDemoView()
    }
}
