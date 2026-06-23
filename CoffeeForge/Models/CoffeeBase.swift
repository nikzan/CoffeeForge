import Foundation

enum CoffeeBase: String, Codable, CaseIterable, Identifiable {
    case espresso
    case americano
    case cappuccino
    case latte
    case raf

    var id: Self { self }

    var displayName: String {
        switch self {
        case .espresso: return "Эспрессо"
        case .americano: return "Американо"
        case .cappuccino: return "Капучино"
        case .latte: return "Латте"
        case .raf: return "Раф"
        }
    }

    var basePrice: Int {
        switch self {
        case .espresso: return 100
        case .americano: return 120
        case .cappuccino: return 150
        case .latte: return 170
        case .raf: return 190
        }
    }
}