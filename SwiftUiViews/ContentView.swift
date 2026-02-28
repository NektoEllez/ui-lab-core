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
                    router.destination(for: route, toastStore: toastStore)
                }
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
                Section {
                    ForEach(section.items) { item in
                        NavigationLink(value: item.route) {
                            ComponentCatalogRow(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    SectionHeaderView(title: section.title)
                }
                .headerProminence(.increased)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }
}

private struct ComponentCatalogRow: View {
    let item: ComponentCatalogItem

    var body: some View {
        HStack(spacing: 14) {
            iconBadge
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                Text("Open demo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
        }
        .padding(.vertical, 6)
    }

    private var iconBadge: some View {
        Image(systemName: item.icon)
            .font(.headline)
            .foregroundStyle(.primary)
            .frame(width: 36, height: 36)
            .background(.quaternary.opacity(0.3), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    ContentView()
        .environment(AppRouter())
        .environment(\.toastStore, ToastStore())
}
