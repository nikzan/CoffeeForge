import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: JSONStore

    var body: some View {
        NavigationStack {
            Group {
                if store.orders.isEmpty {
                    ContentUnavailableView(
                        "История пуста",
                        systemImage: "clock.arrow.circlepath",
                        description: Text("Соберите заказ в конструкторе и нажмите «Заказать»")
                    )
                } else {
                    List {
                        ForEach(store.orders) { order in
                            NavigationLink {
                                OrderDetailView(order: order)
                            } label: {
                                OrderRowView(order: order)
                            }
                        }
                        .onDelete { indexSet in
                            for i in indexSet {
                                store.deleteOrder(store.orders[i].id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("История")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !store.orders.isEmpty {
                        EditButton()
                    }
                }
            }
        }
        .tint(.cfCinnamon)
        .onAppear { store.loadOrders() }
    }
}

// MARK: - Order Row

private struct OrderRowView: View {
    let order: Order

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(order.config.coffeeBase.displayName)
                    .font(.headline)
                Text("\(order.config.cupSize.displayName) · \(order.config.milkType.displayName) · \(order.config.quantity) шт.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(dateFormatter.string(from: order.date))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            Spacer()
            Text(order.config.orderTotal, format: .currency(code: "RUB").locale(Locale(identifier: "ru_RU")))
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.cfCinnamon)
                .monospacedDigit()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Order Detail

struct OrderDetailView: View {
    let order: Order

    var body: some View {
        Form {
            Section("Детали заказа") {
                PriceRow(label: order.config.coffeeBase.displayName, value: order.config.coffeeBase.basePrice)
                PriceRow(label: "Размер \(order.config.cupSize.displayName)", value: order.config.cupSize.price)
                PriceRow(label: "Молоко: \(order.config.milkType.displayName)", value: order.config.milkPrice)
                PriceRow(label: "Сироп: \(order.config.syrup.displayName)", value: order.config.syrupPrice)
                Divider()
                PriceRow(label: "Итого за стакан", value: order.config.cupTotal, isTotal: true)
                PriceRow(label: "Заказ (\(order.config.quantity) шт.)", value: order.config.orderTotal, isTotal: true)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.cfPaper)
        .navigationTitle(order.config.coffeeBase.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HistoryView()
        .environmentObject(JSONStore())
}