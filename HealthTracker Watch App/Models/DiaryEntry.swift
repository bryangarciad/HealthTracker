import Foundation

enum EntryType: String, Codable, CaseIterable {
    case calories = "calories"
    case water = "water"
}

struct DiaryEntry: Identifiable, Codable {
    let id: UUID
    let type: EntryType
    let value: Double
    let timestamp: Date
    
    init(id: UUID = UUID(), type: EntryType, value: Double, timestamp: Date = Date()) {
        self.id = id
        self.type = type
        self.value = value
        self.timestamp = timestamp
    }
}
