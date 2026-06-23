import SwiftUI

struct RootTabView: View {
    @StateObject private var store = JSONStore()

    var body: some View {
        TabView {
            BuilderView()
                .tabItem {
                    Label("Конструктор", systemImage: "cup.and.saucer")
                }

            HistoryView()
                .tabItem {
                    Label("История", systemImage: "clock.arrow.circlepath")
                }

            FavoritesView()
                .tabItem {
                    Label("Избранное", systemImage: "heart")
                }
        }
        .environmentObject(store)
        .onAppear {
            // Кастомный tab bar appearance — тёплая тема
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.cfPaper
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.cfCaramel
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.cfCaramel
            ]
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.cfLatte
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.cfLatte
            ]
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance

            // Nav bar appearance
            let navAppearance = UINavigationBarAppearance()
            navAppearance.configureWithOpaqueBackground()
            navAppearance.backgroundColor = UIColor.cfPaper
            navAppearance.titleTextAttributes = [.foregroundColor: UIColor.cfEspresso]
            navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.cfEspresso]
            UINavigationBar.appearance().standardAppearance = navAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        }
        .tint(.cfCinnamon)
    }
}