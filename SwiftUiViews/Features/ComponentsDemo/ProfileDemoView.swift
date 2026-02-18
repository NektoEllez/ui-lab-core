//
//  ProfileDemoView.swift
//  SwiftUiViews
//
//  Profile placeholder: avatar, name, Edit.
//  Tap from menu → navigate here.
//

import SwiftUI

struct ProfileDemoView: View {
    var body: some View {
        profileContent
            .navigationTitle("Profile")
            .platformInlineTitleMode()
    }

    private var profileContent: some View {
        List {
            Section {
                profileHeader
            }
            Section {
                editProfileButton
            }
        }
        .platformInsetGroupedListStyle()
    }

    private var profileHeader: some View {
        HStack(spacing: 16) {
            avatarView
            nameBlock
        }
        .padding(.vertical, 8)
    }

    private var avatarView: some View {
        Image(systemName: "person.circle.fill")
            .font(.system(size: 64))
            .foregroundStyle(.secondary)
    }

    private var nameBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("User Name")
                .font(.title2.weight(.semibold))
            Text("user@example.com")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var editProfileButton: some View {
        Button {
            // Edit action
        } label: {
            Label("Edit profile", systemImage: "pencil")
        }
    }
}

#Preview {
    NavigationStack {
        ProfileDemoView()
    }
}
