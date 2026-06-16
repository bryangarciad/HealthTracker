import Foundation
import Combine

extension HealthViewModel {
    func addEntry(
        _ entry: DiaryEntry,
        useHealthKit: Bool,
        onSuccess: @escaping () -> Void
    ) {
        if useHealthKit {
            addToHealthKit(entry, onSuccess: onSuccess)
        } else {
            addToLocalStorage(entry, onSuccess: onSuccess)
        }
    }
    
    
    private func addToHealthKit(_ entry: DiaryEntry, onSuccess: @escaping () -> Void) {
        Task {
            do {
                try await healthStoreDataManager.addEntry(<#T##DiaryEntry#>)
                await refreshTodaysDataAsync()
            } catch {
                await MainActor.run {
                    addToLocalStorage(entry, onSuccess: onSuccess)
                }
            }
        }
    }
    
    private func addToLocalStorage(_ entry: DiaryEntry, onSuccess: @escaping () -> Void) {
        storageManager.addEntry(entry)
        
        switch entry.type {
        case .calories:
            todaysCalories += entry.value
        case .water:
            todaysWater += entry.value
        }
        
        onSuccess()
        
    }
}
