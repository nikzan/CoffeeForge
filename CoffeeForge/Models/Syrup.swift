import Foundation

enum Syrup: String, Codable, CaseIterable, Identifiable {
    case none
    case caramel
    case vanilla
    case hazelnut

    var id: Self { self }

    var displayName: String {
        switch self {
        case .none:     return "Без сиропа"
        case .caramel:  return "Карамель"
        case .vanilla:  return "Ваниль"
        case .hazelnut: return "Лесной орех"
        }
    }

    var price: Int {
        switch self {
        case .none:     return 0
        case .caramel:  return 40
        case .vanilla:  return 40
        case .hazelnut: return 50
        }
    }
}