import Foundation

enum MilkType: String, Codable, CaseIterable, Identifiable {
    case none
    case regular
    case oat
    case coconut

    var id: Self { self }

    var displayName: String {
        switch self {
        case .none:     return "Без молока"
        case .regular:  return "Обычное"
        case .oat:      return "Овсяное"
        case .coconut:  return "Кокосовое"
        }
    }

    var price: Int {
        switch self {
        case .none:     return 0
        case .regular:  return 30
        case .oat:      return 60
        case .coconut:  return 70
        }
    }
}