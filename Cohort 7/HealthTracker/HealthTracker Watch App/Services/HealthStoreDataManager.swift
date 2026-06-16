import Foundation
import Combine
import HealthKit

class HealthStoreDataManager {
    static let shared = HealthStoreDataManager()
    private init() {}
    
    // This is the main interface to interact with health store / healthKit
    let healthStore = HKHealthStore()
    
    // MARK: - HealthKit Types
    // Create the Health Data Types to work with
    private let caloriesType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
    private let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
    private let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
    private let characteristicType = HKCharacteristicType.characteristicType(forIdentifier: .bloodType)!
        
    // MARK: - Units
    private let heartRateUnits = HKUnit(from: "count/min")
    private let caloriesUnit = HKUnit.kilocalorie()
    private let waterUnit = HKUnit.literUnit(with: .milli)
    
    var isHealthKitAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    func requestAuthorization() async throws {
        let typesToRead: Set<HKObjectType> = [caloriesType, waterType, heartRateType, characteristicType]
        
        let typesToWrite: Set<HKSampleType> = [caloriesType, waterType]

        try await healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead)
    }
    
    func checkCriticalAuthorizationStatus() -> Bool {
        let caloriesAuthStatus = healthStore.authorizationStatus(for: caloriesType)
        let waterAuthStatus = healthStore.authorizationStatus(for: waterType)
        
        return ( caloriesAuthStatus == HKAuthorizationStatus.sharingAuthorized &&
             waterAuthStatus == HKAuthorizationStatus.sharingAuthorized )
    }
    
    func checkSecondaryAuthorizationStatus() -> Bool {
        healthStore.authorizationStatus(for: heartRateType) == HKAuthorizationStatus.sharingAuthorized
    }
    
    // MARK: - Simple HKSAMPLEQUERY
    // This function queries and return one single element
    // The query in here is a one time operation if you wanted to
    // get again the newest data point you would need to call this func
    // again and again on a high frequency basis
    func fetchLatestHeartRate() async throws -> HeartRateSample? {
        return try await withCheckedThrowingContinuation { continuation in
            let sortDescriptor = NSSortDescriptor(
                key: HKSampleSortIdentifierStartDate,
                ascending: false // We get data in descending order which means newest first
            )
            
            // predicate is a TIME Predicate (time windows, from Date A -> to Date B) if you pass nil you'll get all data available so make sure to set a limit or you may run into performance issues
            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                // Even though we said we just want 1 element in the limit property
                // queries will always return an ARRAY, so we would get an array
                // with only one element
                guard let sample = samples?.first as? HKQuantitySample else {
                    continuation.resume(returning: nil)
                    return
                }
                
                // Sample right now is a HKQuantitySample which is a very complex and
                // contentfull structure, so our app does not need an struct that complex
                // so lets turn the sample into a more relevant structure
                let bpm = sample.quantity.doubleValue(for: self.heartRateUnits)
                let heartRateSample = HeartRateSample(
                    bpm: bpm, timestamp: sample.startDate
                )

                continuation.resume(returning: heartRateSample)
            }
            
            healthStore.execute(query)
        }
    }
    
    // MARK: Real Time Anchored Example
    // This function gets the heart rate in real time updates
    func startHeartRateMonitoring(onUpdateHandler: @escaping ([HeartRateSample]) -> Void) {
        
        let query = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: nil,
            anchor: nil, // if you set the anchor with nil com will stay open always
            limit: HKObjectQueryNoLimit
        ) { [weak self] _, samples, deletedObjects, _, error in
            guard let self = self else { return }
            self.processHeartRateSamples(samples, onUpdate: onUpdateHandler)
        }
        
        query.updateHandler = { [weak self] query, samples, deletedObjects, anchor, error in
            guard let self = self else { return }
            self.processHeartRateSamples(samples, onUpdate: onUpdateHandler)
        }
        
        healthStore.execute(query)
    }
    
    func processHeartRateSamples(_ samples: [HKSample]?, onUpdate: @escaping ([HeartRateSample]) -> Void) {
        guard let quantitySamples = samples as? [HKQuantitySample],
              !quantitySamples.isEmpty else {
            return
        }
        
        let heartRateSamples = quantitySamples.map { sample in
            let bpm = sample.quantity.doubleValue(for: self.heartRateUnits)
            return HeartRateSample(
                bpm: bpm, timestamp: sample.startDate
            )
        }
        
        DispatchQueue.main.async {
            onUpdate(heartRateSamples)
        }
    }
    
    // MARK: - Calories and Wather Methods
    func getHealthKitTypeAndUnitForEntries(for type: EntryType) -> (HKQuantityType, HKUnit) {
        switch type {
        case .calories: return (caloriesType, caloriesUnit)
        case .water: return (waterType, waterUnit)
        }
    }
    
    func getTodaysTimePredicate() -> NSPredicate {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        
        return HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
    }
    
    
    func getTodaysTotal(for type: EntryType) async throws -> Double {
        return try await withCheckedThrowingContinuation { continuation in
            let (hkType, unit) = getHealthKitTypeAndUnitForEntries(for: type)
            let predicate = getTodaysTimePredicate()
            
            let query = HKStatisticsQuery(
                quantityType: hkType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, statistics, error in
                if let error = error as NSError? {
                    continuation.resume(returning: 0.0)
                    return
                }
                
                let todaysTotal = statistics?.sumQuantity()?.doubleValue(for: unit) ?? 0.0
                continuation.resume(returning: todaysTotal)
            }
            
            healthStore.execute(query)
        }
    }
    
    func addEntry(_ entry: DiaryEntry) async throws {
        let (hkType, unit) = getHealthKitTypeAndUnitForEntries(for: entry.type)
        
        let sample = createHealthKitSampleFromQuantityTypes(
            type: hkType,
            unit: unit,
            value: entry.value,
            timestamp: entry.timestamp
        )
        
        try await healthStore.save(sample)
    }
}
