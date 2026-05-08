//
//  HealthTrackerApp.swift
//  HealthTracker Watch App
//
//  Created by Ramses Garcia on 23/04/26.
//

import SwiftUI
import WatchKit

@main
struct HealthTracker_Watch_AppApp: App {
    @StateObject private var viewModel = HealtTrackerViewModel()
    @StateObject private var motionManager = MotionManager.shared
    
    @State private var showQuickActions: Bool = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainDashboardView(viewModel: viewModel, currentActivity: motionManager.currentUserActivity)
            }
            .onAppear {
                viewModel.refreshTodaysData()
                Task {
                    await viewModel.requestHealthKitAuth()
                }
                motionManager.startShakeDetection()
                motionManager.startActivityTracking()
            }.onChange(of: motionManager.shakeDetected) { _, newValue in
                if newValue {
                    showQuickActions = true
                    WKInterfaceDevice.current().play(.success)
                }
            }
            
            if showQuickActions {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showQuickActions = false
                    }
                // Challenge
                // We can show a sheet with buttons to navigate to places quickly
                // just do something concise like navigating to settings
            }
        }
    }
}
