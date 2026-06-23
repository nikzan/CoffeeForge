import SwiftUI
import Combine

private let ordersKey = "cf_orders"
private let favoritesKey = "cf_favorites"

/// Простое JSON-хранилище на @AppStorage для истории заказов и избранного.
/// Codable в both ends — модель Order/Favorite сами знают как сериализоваться.
final class JSONStore: ObservableObject {
    @AppStorage(ordersKey) private var ordersData: Data = Data()
    @AppStorage(favoritesKey) private var favoritesData: Data = Data()

    // MARK: - Orders

    @Published private(set) var orders: [Order] = [] {
        didSet { saveOrders() }
    }

    func loadOrders() {
        orders = (try? JSONDecoder().decode([Order].self, from: ordersData)) ?? []
    }

    func addOrder(_ order: Order) {
        loadOrders()
        orders.insert(order, at: 0)
    }

    func deleteOrder(_ id: UUID) {
        loadOrders()
        orders.removeAll { $0.id == id }
    }

    private func saveOrders() {
        ordersData = (try? JSONEncoder().encode(orders)) ?? Data()
    }

    // MARK: - Favorites

    @Published private(set) var favorites: [Favorite] = [] {
        didSet { saveFavorites() }
    }

    func loadFavorites() {
        favorites = (try? JSONDecoder().decode([Favorite].self, from: favoritesData)) ?? []
    }

    func addFavorite(_ fav: Favorite) {
        loadFavorites()
        favorites.insert(fav, at: 0)
    }

    func deleteFavorite(_ id: UUID) {
        loadFavorites()
        favorites.removeAll { $0.id == id }
    }

    private func saveFavorites() {
        favoritesData = (try? JSONEncoder().encode(favorites)) ?? Data()
    }
}