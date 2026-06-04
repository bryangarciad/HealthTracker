import Foundation
import Combine
import SwiftUI

enum EntryType: String, Codable, CaseIterable {
    case water = "water"
    case calories = "calories"
    
    // Computed Properties
    var color: Color {
        switch self {
        case .water: return Color.cyan
        case .calories: return Color.orange
        }
    }
    
    var icon: String {
        switch self {
        case .water: return "drop.fill"
        case .calories: return "flame.fillß"
        }
    }
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
