//
//  HealthTrackerApp.swift
//  HealthTracker Watch App
//
//  Created by Ramses Garcia on 23/04/26.
//

import SwiftUI

@main
struct HealthTracker_Watch_AppApp: App {
    @StateObject private var viewModel = HealtTrackerViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainDashboardView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.refreshTodaysData()
            }
        }
    }
}
