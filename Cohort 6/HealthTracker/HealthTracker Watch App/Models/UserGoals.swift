import Foundation
import Combine

struct UserGoals: Codable {
    var dailyCaloriesGoal: Double // 2000 cal
    var dailyWaterGoal: Double // 2000 ml
    
    static let defaultGoals = UserGoals(
        dailyCaloriesGoal: 2000,
        dailyWaterGoal: 2000
    )
}
