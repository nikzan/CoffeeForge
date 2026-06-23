import SwiftUI

// MARK: - PriceRow
/// Кастомный переиспользуемый View для отображения строки стоимости.
/// Используется во всех строках секции «Итог».
struct PriceRow: View {
    let label: String
    let value: Int
    var isTotal: Bool = false
    var isSeparator: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(isTotal ? .body.weight(.semibold) : .body)
                .foregroundStyle(Color.cfEspresso)
            Spacer()
            if isSeparator {
                Divider()
                    .frame(width: 24)
                    .overlay(Color.cfLatte)
            } else {
                Text(value, format: .currency(code: "RUB").locale(Locale(identifier: "ru_RU")))
                    .font(isTotal ? .title3.weight(.bold) : .body)
                    .foregroundStyle(isTotal ? Color.cfCinnamon : Color.cfEspresso)
                    .monospacedDigit()
            }
        }
        .padding(.vertical, isTotal ? 6 : 2)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 8) {
        PriceRow(label: "Базовая стоимость", value: 250)
        PriceRow(label: "Молоко", value: 60)
        PriceRow(label: "Сироп", value: 40)
        Divider()
        PriceRow(label: "Итого за стакан", value: 350, isTotal: true)
        PriceRow(label: "Итого за заказ (2 шт)", value: 700, isTotal: true)
    }
    .padding()
    .background(Color.cfPaper)
}