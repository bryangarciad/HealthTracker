//
//  UserGoals.swift
//  HealthTracker Watch App
//
//  Holds the daily targets the user is trying to hit. Small and simple — but
//  notice it is `Codable` too, so we can save the user's chosen goals and
//  reload them next time the app opens.
//

import Foundation

struct UserGoals: Codable {
    var dailyCaloriesGoal: Double
    var dailyWaterGoal: Double

    // A `static` value belongs to the TYPE itself, not to one instance.
    // We use it as a sensible fallback the very first time the app runs,
    // before the user has set their own goals.
    static let defaultGoals = UserGoals(
        dailyCaloriesGoal: 2000,
        dailyWaterGoal: 2000
    )
}
