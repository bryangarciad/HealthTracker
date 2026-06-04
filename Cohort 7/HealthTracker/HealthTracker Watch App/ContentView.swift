//
//  ContentView.swift
//  HealthTracker Watch App
//
//  Created by Ramses Garcia on 01/06/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var healthViewModel = HealthViewModel()
    
    var body: some View {
        NavigationStack {
            MainDashboardView(healthViewModel: healthViewModel)
        }
        .onAppear {
            // refresh the current daily totals
            healthViewModel.refreshDailyTotals()
        }
    }
}

#Preview {
    ContentView()
}
