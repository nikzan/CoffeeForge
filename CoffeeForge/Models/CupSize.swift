import Foundation

enum CupSize: String, Codable, CaseIterable, Identifiable {
    case small  // S
    case medium // M
    case large  // L

    var id: Self { self }

    var displayName: String {
        switch self {
        case .small:  return "S"
        case .medium: return "M"
        case .large:  return "L"
        }
    }

    var price: Int {
        switch self {
        case .small:  return 150
        case .medium: return 200
        case .large:  return 300
        }
    }
}