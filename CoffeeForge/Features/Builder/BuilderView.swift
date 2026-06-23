import SwiftUI

struct BuilderView: View {
    // ТЗ: параметры в @State? Да, они хранится в @State
    // как один объект, а все цены — вычисляемые свойства DrinkConfig.
    @State private var config = DrinkConfig()
    @State private var showingSaved = false

    @EnvironmentObject var store: JSONStore

    var body: some View {
        NavigationStack {
            Form {
                // MARK: Превью стакана
                Section {
                    CupPreview(config: config)
                        .frame(maxWidth: .infinity)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }

                // MARK: Напиток
                Section("Напиток") {
                    Picker("Основа", selection: $config.coffeeBase) {
                        ForEach(CoffeeBase.allCases) { base in
                            Text(base.displayName).tag(base)
                        }
                    }
                }

                // MARK: Размер
                Section("Размер") {
                    Picker("Объём", selection: $config.cupSize) {
                        ForEach(CupSize.allCases) { size in
                            Text(size.displayName).tag(size)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // MARK: Молоко
                Section("Молоко") {
                    Picker("Тип молока", selection: $config.milkType) {
                        ForEach(MilkType.allCases) { milk in
                            HStack {
                                Text(milk.displayName)
                                if milk.price > 0 {
                                    Spacer()
                                    Text(milk.price, format: .currency(code: "RUB").locale(Locale(identifier: "ru_RU")))
                                        .foregroundStyle(.secondary)
                                        .monospacedDigit()
                                }
                            }
                            .tag(milk)
                        }
                    }
                }

                // MARK: Сироп
                Section("Сироп") {
                    Picker("Добавка", selection: $config.syrup) {
                        ForEach(Syrup.allCases) { syrup in
                            HStack {
                                Text(syrup.displayName)
                                if syrup.price > 0 {
                                    Spacer()
                                    Text(syrup.price, format: .currency(code: "RUB").locale(Locale(identifier: "ru_RU")))
                                        .foregroundStyle(.secondary)
                                        .monospacedDigit()
                                }
                            }
                            .tag(syrup)
                        }
                    }
                }

                // MARK: Количество
                Section("Количество") {
                    Stepper("\(config.quantity) шт.", value: $config.quantity, in: 1...10)
                        .onChange(of: config.quantity) { _ in
                            Haptics.selectionChanged()
                        }
                }

                // MARK: Итог
                Section("Итог") {
                    PriceRow(label: "Базовая стоимость (\(config.cupSize.displayName))", value: config.basePrice)
                    PriceRow(label: "Молоко", value: config.milkPrice)
                    PriceRow(label: "Сироп", value: config.syrupPrice)

                    PriceRow(label: "Итого за стакан", value: config.cupTotal)
                    PriceRow(label: "Заказ (\(config.quantity) шт.)", value: config.orderTotal, isTotal: true)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.cfPaper)
            .navigationTitle("CoffeeForge")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Haptics.mediumImpact()
                        showingSaved = true
                    } label: {
                        Label("Сохранить", systemImage: "heart")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let order = Order(config: config)
                        store.addOrder(order)
                        Haptics.notification(.success)
                    } label: {
                        Label("Заказать", systemImage: "cup.and.saucer.fill")
                    }
                }
            }
            .sheet(isPresented: $showingSaved) {
                saveFavoriteSheet
            }
        }
        .tint(.cfCinnamon)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: config)
    }

    // MARK: - Save Favorite Sheet

    @State private var favoriteName = ""

    @ViewBuilder
    private var saveFavoriteSheet: some View {
        NavigationStack {
            Form {
                Section("Название рецепта") {
                    TextField("Например: Утренний латте", text: $favoriteName)
                }
                Section {
                    DrinkSummaryView(config: config)
                }
            }
            .navigationTitle("В избранное")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { showingSaved = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let fav = Favorite(
                            name: favoriteName.isEmpty ? "Рецепт" : favoriteName,
                            config: config
                        )
                        store.addFavorite(fav)
                        Haptics.notification(.success)
                        showingSaved = false
                        favoriteName = ""
                    }
                }
            }
        }
        .tint(.cfCinnamon)
    }
}

// MARK: - Drink Summary View

private struct DrinkSummaryView: View {
    let config: DrinkConfig

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(config.coffeeBase.displayName) (\(config.cupSize.displayName))")
                .font(.headline)
            Text("Молоко: \(config.milkType.displayName)")
                .font(.subheadline).foregroundStyle(.secondary)
            if config.syrup != .none {
                Text("Сироп: \(config.syrup.displayName)")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            Text("\(config.quantity) шт. × \(config.cupTotal) ₽ = \(config.orderTotal) ₽")
                .font(.subheadline.weight(.medium))
                .padding(.top, 4)
        }
    }
}

#Preview {
    BuilderView()
        .environmentObject(JSONStore())
}