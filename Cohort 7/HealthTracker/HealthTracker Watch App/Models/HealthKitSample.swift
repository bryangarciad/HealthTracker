import Foundation
import Combine
import HealthKit

func createHealthKitSampleFromQuantityTypes(
    type: HKQuantityType,
    unit: HKUnit,
    value: Double,
    timestamp: Date
) -> HKQuantitySample {
    let quantinty = HKQuantity(unit: unit, doubleValue: value) // hk recognizes quantities as the combination of value and unit
    
    return HKQuantitySample(
        type: type, quantity: quantinty, start: timestamp, end: timestamp
    )
}
