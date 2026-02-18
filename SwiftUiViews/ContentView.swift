import SwiftUI

struct ContentView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.toastStore) private var toastStore

    var body: some View {
        NavigationStack(path: pathBinding) {
            componentsList
                .navigationTitle("SwiftUI Components")
                .platformLargeTitleMode()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .toast:
            if let store = toastStore {
                ToastDemoView(toastStore: store)
                    .toastOverlay(alignment: .top)
            } else {
                EmptyView()
            }
        default:
            router.destination(for: route)
                .environment(\.toastStore, toastStore)
        }
    }

    private var pathBinding: Binding<[Route]> {
        Binding(
            get: { router.path },
            set: { router.path = $0 }
        )
    }

    /// NavigationLink(value:) — проще редактировать; destination по-прежнему один navigationDestination.
    private var componentsList: some View {
        List {
            ForEach(ComponentCatalog.sections) { section in
                Section(section.title) {
                    ForEach(section.items) { item in
                        NavigationLink(value: item.route) {
                            Label(item.title, systemImage: item.icon)
                        }
                        .listRowInsets(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AppRouter())
        .environment(\.toastStore, ToastStore())
}
