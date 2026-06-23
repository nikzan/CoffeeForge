import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var store: JSONStore
    @State private var selectedConfig: DrinkConfig?

    var body: some View {
        NavigationStack {
            Group {
                if store.favorites.isEmpty {
                    ContentUnavailableView(
                        "Нет сохранённых рецептов",
                        systemImage: "heart.slash",
                        description: Text("Сохраните свою комбинацию из конструктора")
                    )
                } else {
                    List {
                        ForEach(store.favorites) { fav in
                            Button {
                                selectedConfig = fav.config
                            } label: {
                                FavoriteRowView(fav: fav)
                            }
                            .foregroundStyle(.primary)
                        }
                        .onDelete { indexSet in
                            for i in indexSet {
                                store.deleteFavorite(store.favorites[i].id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Избранное")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !store.favorites.isEmpty {
                        EditButton()
                    }
                }
            }
            .sheet(item: $selectedConfig) { config in
                FavoriteDetailSheet(config: config)
            }
        }
        .tint(.cfCinnamon)
        .onAppear { store.loadFavorites() }
    }
}

// MARK: - Favorite Row

private struct FavoriteRowView: View {
    let fav: Favorite

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(fav.name)
                    .font(.headline)
                Text("\(fav.config.coffeeBase.displayName) (\(fav.config.cupSize.displayName))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Молоко: \(fav.config.milkType.displayName) · Сироп: \(fav.config.syrup.displayName)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            Spacer()
            Text(fav.config.orderTotal, format: .currency(code: "RUB").locale(Locale(identifier: "ru_RU")))
                .font(.title3.weight(.semibold))
                .foregroundStyle(.cfCinnamon)
                .monospacedDigit()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Favorite Detail Sheet

struct FavoriteDetailSheet: View {
    @EnvironmentObject var store: JSONStore
    @Environment(\.dismiss) private var dismiss
    let config: DrinkConfig

    var body: some View {
        NavigationStack {
            Form {
                Section("Превью") {
                    CupPreview(config: config)
                        .frame(maxWidth: .infinity)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }

                Section("Состав") {
                    PriceRow(label: config.coffeeBase.displayName, value: config.coffeeBase.basePrice)
                    PriceRow(label: "Размер \(config.cupSize.displayName)", value: config.cupSize.price)
                    PriceRow(label: "Молоко: \(config.milkType.displayName)", value: config.milkPrice)
                    PriceRow(label: "Сироп: \(config.syrup.displayName)", value: config.syrupPrice)
                    Divider()
                    PriceRow(label: "Итого за стакан", value: config.cupTotal, isTotal: true)
                    PriceRow(label: "Заказ (1 шт.)", value: config.cupTotal, isTotal: true)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.cfPaper)
            .navigationTitle("Рецепт")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") { dismiss() }
                }
            }
        }
        .tint(.cfCinnamon)
    }
}

extension DrinkConfig: Identifiable {
    var id: String { "\(coffeeBase)-\(cupSize)-\(milkType)-\(syrup)-\(quantity)" }
}

#Preview {
    FavoritesView().environmentObject(JSONStore())
}