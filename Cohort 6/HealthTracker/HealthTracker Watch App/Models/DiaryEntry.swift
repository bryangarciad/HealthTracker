import Foundation
import SwiftUI

enum EntryType: String, Codable, CaseIterable {
    case calories = "calories"
    case water = "water"
    
    var icon: String {
        switch self {
        case .calories: return "flame.fill"
        case .water: return "drop.fill"
        }
        
    }

    var color: Color {
        switch self {
        case .calories: return .orange
        case .water: return .cyan
        }
    }
}

struct DiaryEntry: Identifiable, Codable {
    let id: UUID
    let type: EntryType
    let value: Double
    let timestamp: Date // 2026-04-25T10:21:12.0000-00:06
    
    init(id: UUID = UUID(), type: EntryType, value: Double, timestamp: Date = Date()) {
        self.id = id
        self.type = type
        self.value = value
        self.timestamp = timestamp
    }
}
