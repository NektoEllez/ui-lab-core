//
//  TemplatesDemoView.swift
//  SwiftUiViews
//
//  Demo screen for foundational template views used in many apps.
//

import SwiftUI

struct TemplatesDemoView: View {
    @State private var phase: StateContainerPhase = .loading
    @State private var showBottomSheet = false
    @State private var phaseTask: Task<Void, Never>?

    var body: some View {
        List {
            avatarsSection
            badgesSection
            skeletonsSection
            stateContainerSection
            asyncImageCardSection
            sectionCardSection
            permissionPromptSection
            bottomSheetSection
        }
        .navigationTitle("Template Kit")
        .platformInlineTitleMode()
        .platformInsetGroupedListStyle()
        .onDisappear {
            phaseTask?.cancel()
            phaseTask = nil
        }
    }

    private var avatarsSection: some View {
        Section("Avatar") {
            HStack(spacing: 16) {
                AvatarView(initials: "AB")
                AvatarView(initials: "UI", size: 52, presence: .online)
                AvatarView(initials: "SK", size: 60, presence: .offline)
            }
            .padding(.vertical, 8)
        }
    }

    private var badgesSection: some View {
        Section("Badge") {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 72), spacing: 8)], alignment: .leading, spacing: 8) {
                BadgeView("New")
                BadgeView("Pro", tone: .info)
                BadgeView("Stable", tone: .success)
                BadgeView("Warning", tone: .warning)
                BadgeView("Error", tone: .danger)
            }
            .padding(.vertical, 4)
        }
    }

    private var skeletonsSection: some View {
        Section("Skeleton") {
            VStack(alignment: .leading, spacing: 12) {
                SkeletonBlockView(height: 18)
                SkeletonBlockView(height: 14)
                SkeletonBlockView(height: 14)
                    .frame(maxWidth: 220)
            }
            .padding(.vertical, 8)
        }
    }

    private var stateContainerSection: some View {
        Section("State Container") {
            StateContainerView(
                phase: phase,
                retryAction: {
                    scheduleStateContainerLoad()
                }
            ) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Loaded content")
                        .font(.headline)
                    Text("This area is rendered only for .content state.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(.thinMaterial, in: .rect(cornerRadius: 10))
            }

            ViewThatFits {
                HStack(spacing: 8) {
                    phaseButton("Load", phase: .loading)
                    phaseButton("Empty", phase: .empty(title: "No data", message: "Create your first item."))
                    phaseButton("Error", phase: .error(message: "Network unavailable"))
                    phaseButton("Done", phase: .content)
                }

                VStack(alignment: .leading, spacing: 8) {
                    phaseButton("Load", phase: .loading)
                    phaseButton("Empty", phase: .empty(title: "No data", message: "Create your first item."))
                    phaseButton("Error", phase: .error(message: "Network unavailable"))
                    phaseButton("Done", phase: .content)
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
    }

    private var asyncImageCardSection: some View {
        Section("Async Image Card") {
            AsyncImageCardView(
                url: URL(string: "https://picsum.photos/460/280"),
                title: "Remote media card",
                subtitle: "Displays loading, success and error states"
            )
        }
    }

    private var sectionCardSection: some View {
        Section("Section Card") {
            SectionCardView(
                title: "Account",
                subtitle: "Main profile settings",
                actionTitle: "Edit",
                action: {}
            ) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Name: Alex")
                    Text("Plan: Pro")
                    Text("Region: US")
                }
                .font(.subheadline)
            }
        }
    }

    private var permissionPromptSection: some View {
        Section("Permission Prompt") {
            PermissionPromptView(
                icon: "location.fill",
                title: "Allow location access",
                message: "Needed to show nearby places and delivery ETA.",
                buttonTitle: "Allow",
                action: {}
            )
        }
    }

    private var bottomSheetSection: some View {
        Section("Bottom Sheet Scaffold") {
            Button("Open demo bottom sheet") {
                showBottomSheet = true
            }
            .buttonStyle(.borderedProminent)
            .bottomSheetScaffold(isPresented: $showBottomSheet) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Reusable Bottom Sheet")
                        .font(.headline)
                    Text("Use this scaffold for consistent detents, corners and drag indicator.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button("Close") {
                        showBottomSheet = false
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
    }

    private func phaseButton(_ title: String, phase: StateContainerPhase) -> some View {
        Button(title) {
            self.phase = phase
        }
    }

    private func scheduleStateContainerLoad() {
        phaseTask?.cancel()
        phase = .loading
        phaseTask = Task { @MainActor in
            do {
                try await Task.sleep(for: .seconds(0.8))
            } catch {
                return
            }
            withAnimation(.snappy(duration: 0.25)) {
                phase = .content
            }
        }
    }
}

#Preview {
    NavigationStack {
        TemplatesDemoView()
    }
}
