//
//  Route.swift
//  SwiftUiViews
//
//  Type-safe navigation routes with UI metadata and destination mapping.
//

import SwiftUI

enum Route: String, Hashable {
    case buttons
    case textFields
    case toast
    case banners
    case lists
    case messageList
    case bottomBar
    case chips
    case templates
    case moreComponents
    case settings
    case notifications
    case profile
    case help

    var title: String {
        switch self {
        case .buttons: "Buttons"
        case .textFields: "Text fields"
        case .toast: "Toast"
        case .banners: "Banners"
        case .lists: "Lists (menu)"
        case .messageList: "Message list"
        case .bottomBar: "Bottom bar / Footer"
        case .chips: "Chips"
        case .templates: "Templates & Scaffolds"
        case .moreComponents: "Overlay, card & search"
        case .settings: "Settings"
        case .notifications: "Notifications"
        case .profile: "Profile"
        case .help: "Help"
        }
    }

    var icon: String {
        switch self {
        case .buttons: "hand.tap"
        case .textFields: "textformat"
        case .toast: "bell.badge"
        case .banners: "rectangle.portrait.topthird.inset.filled"
        case .lists: "list.bullet"
        case .messageList: "envelope"
        case .bottomBar: "rectangle.bottomhalf.inset.filled"
        case .chips: "circle.grid.2x2"
        case .templates: "square.grid.3x3.topleft.filled"
        case .moreComponents: "square.stack.3d.up"
        case .settings: "gearshape"
        case .notifications: "bell"
        case .profile: "person.crop.circle"
        case .help: "questionmark.circle"
        }
    }

    @ViewBuilder
    func destination(toastStore: ToastStore?) -> some View {
        switch self {
        case .buttons:
            ButtonsDemoView()
        case .textFields:
            TextFieldsDemoView()
        case .toast:
            if let toastStore {
                ToastDemoView(toastStore: toastStore)
                    .toastOverlay(alignment: .top)
            } else {
                EmptyView()
            }
        case .banners:
            BannersDemoView()
        case .lists:
            ListsDemoView()
        case .messageList:
            MessageListDemoView()
        case .bottomBar:
            BottomBarDemoView()
        case .chips:
            ChipsDemoView()
        case .templates:
            TemplatesDemoView()
        case .moreComponents:
            MoreComponentsDemoView()
        case .settings:
            SettingsDemoView()
        case .notifications:
            NotificationsDemoView()
        case .profile:
            ProfileDemoView()
        case .help:
            HelpDemoView()
        }
    }
}
