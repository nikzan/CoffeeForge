import Foundation

struct Order: Codable, Identifiable {
    let id: UUID
    var config: DrinkConfig
    let date: Date
    var note: String?

    init(id: UUID = UUID(), config: DrinkConfig, date: Date = Date(), note: String? = nil) {
        self.id = id
        self.config = config
        self.date = date
        self.note = note
    }
}

struct Favorite: Codable, Identifiable {
    let id: UUID
    var name: String
    var config: DrinkConfig

    init(id: UUID = UUID(), name: String, config: DrinkConfig) {
        self.id = id
        self.name = name
        self.config = config
    }
}