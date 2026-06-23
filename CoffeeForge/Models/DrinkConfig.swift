import Foundation

struct DrinkConfig: Codable, Equatable {
    var coffeeBase: CoffeeBase = .cappuccino
    var cupSize: CupSize = .medium
    var milkType: MilkType = .regular
    var syrup: Syrup = .none
    var quantity: Int = 1

    // --- Computed properties (ТЗ: все цены — вычисляемые) ---

    /// Базовая стоимость напитка = цена размера стакана.
    /// Стоимость кофейной основы уже заложена в цену размера, отдельно не считается.
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
        basePrice + milkPrice + syrupPrice
    }

    /// Итоговая стоимость всего заказа (количество стаканов)
    var orderTotal: Int {
        cupTotal * quantity
    }
}