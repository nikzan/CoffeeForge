import Foundation

struct DrinkConfig: Codable, Equatable {
    var coffeeBase: CoffeeBase = .cappuccino
    var cupSize: CupSize = .medium
    var milkType: MilkType = .regular
    var syrup: Syrup = .none
    var quantity: Int = 1

    // --- Computed properties (ТЗ: все цены — вычисляемые) ---

    /// Базовая стоимость с учётом размера стакана (сейчас просто размер; можно scale)
    var basePrice: Int {
        cupSize.price
    }

    /// Стоимость добавленного молока
    var milkPrice: Int {
        milkType.price
    }

    /// Стоимость добавленного сиропа
    var syrupPrice: Int {
        syrup.price
    }

    /// Итоговая стоимость одного стакана
    var cupTotal: Int {
        let base = coffeeBase.basePrice + cupSize.price
        return base + milkPrice + syrupPrice
    }

    /// Итоговая стоимость всего заказа (количество стаканов)
    var orderTotal: Int {
        cupTotal * quantity
    }
}