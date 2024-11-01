
//  HKService.swift
//  Steps
//
//  Created by christian on 7/15/24.
//

import Foundation
import HealthKit
import Observation

@MainActor
@Observable
final class HealthKitData: Sendable {
    var steps: [HealthMetric] = []
    var weights: [HealthMetric] = []
    var weightDiffs: [HealthMetric] = []
}

@MainActor
@Observable
final class HealthKitService {
    
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
    
    /// Add pre-defined mock data to HealthKit on the Simulator
    func addSampleData() async {
        
        var sampleData: [HKQuantitySample] = []
        
        for i in 0...28 {
            let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4_000...20_000))
            let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: 160 + Double(i/3)...165 + Double(i/3)))
            
            let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now)!
            let endDate = Calendar.current.date(byAdding: .minute, value: .random(in: 120...3600), to: startDate)!
            
            let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: startDate, end: endDate)
            let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass),quantity: weightQuantity,start: startDate,end: endDate)
            
            sampleData.append(stepSample)
            sampleData.append(weightSample)
        }
        
        try! await store.save(sampleData)
        print("✅ Sample data added.")
    }
    
    /// Write step count data to HealthKit. This requires HealthKit write permission.
    /// - Parameters:
    ///   - date: Date for step count value
    ///   - value: Step count value
    func addStepData(for date: Date, value: Double) async throws {
        let status = store.authorizationStatus(for: HKQuantityType(.stepCount))
        
        switch status {
        case .notDetermined:
            throw STError.authNotDetermined
        case .sharingDenied:
            throw STError.sharingDenied(quantityType: "Step Count")
        case .sharingAuthorized:
            break
        @unknown default:
            break
        }
        
        let stepQuantity = HKQuantity(unit: .count(), doubleValue: value)
        let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: date, end: date)
        
        do {
            try await store.save(stepSample)
        } catch {
            throw STError.unableToCompleteRequest
        }
    }
    
    /// Write weight value to HealthKit. Requires HealthKit write permission.
    /// - Parameters:
    ///   - date: Date for weight value
    ///   - value: Weight value in pounds used for .bodyMass conversion
    func addWeightData(for date: Date, value: Double) async throws {
        let status = store.authorizationStatus(for: HKQuantityType(.bodyMass))
        
        switch status {
        case .notDetermined:
            throw STError.authNotDetermined
        case .sharingDenied:
            throw STError.sharingDenied(quantityType: "Weight")
        case .sharingAuthorized:
            break
        @unknown default:
            break
        }
        let weightQuantity = HKQuantity(unit: .pound(), doubleValue: value)
        let weightSample = HKQuantitySample(
            type: HKQuantityType(.bodyMass),
            quantity: weightQuantity,
            start: date,
            end: date
        )
        
        do {
            try await store.save(weightSample)
        } catch {
            throw STError.unableToCompleteRequest
        }
    }
    
    /// Creates a DateInterval from a provided end date and range
    /// - Parameters:
    ///   - date: End of date interval
    ///   - daysBack: Number of days prior to end date
    /// - Returns: Date range as DateInterval.
    private func createDateInterval(from date: Date, daysBack: Int) -> DateInterval {
        let calendar = Calendar(identifier: .gregorian)
        let startOfEndDate = calendar.startOfDay(for: .now) // 12:00AM on endDate
        let endDate = calendar.date(byAdding: .day, value: 1, to: startOfEndDate)!
        let startDate = calendar.date(byAdding: .day, value: -daysBack, to: endDate)!
        
        return .init(start: startDate, end: endDate)
    }
    
    /// Fetch last 28 days of step count from HealthKit
    ///
    /// Further description
    /// - Returns: Array of ``HealthMetric``
    func fetchStepCount() async throws -> [HealthMetric] {
        guard store.authorizationStatus(for: HKQuantityType(.stepCount)) != .notDetermined else {
            throw STError.authNotDetermined
        }
        
        let interval = createDateInterval(from: .now, daysBack: 28)
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: interval.start, end: interval.end)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.stepCount), predicate: queryPredicate)
        
        let stepsQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: samplePredicate,
            options: .cumulativeSum,
            anchorDate: interval.end,
            intervalComponents: .init(day: 1)
        )
        
        do {
            let stepCounts = try await stepsQuery.result(for: store)
            
            return stepCounts.statistics().map {
                .init(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            }
        } catch HKError.errorNoData {
            throw STError.noData
        } catch {
            throw STError.unableToCompleteRequest
        }
    }
    
    /// Fetch most recent weight sample on each day for a specified number of days back from today.
    /// - Parameter daysBack: Days back from today. Ex: 28 will return the last 28 days of weight values.
    /// - Returns: Array of ``HealthMetric``
    func fetchWeights(daysBack: Int) async throws -> [HealthMetric] {
        guard store.authorizationStatus(for: HKQuantityType(.stepCount)) != .notDetermined else {
            throw STError.authNotDetermined
        }
        
        let interval = createDateInterval(from: .now, daysBack: daysBack)
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: interval.start, end: interval.end)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.bodyMass), predicate: queryPredicate)
        
        let weightQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: samplePredicate,
            options: .mostRecent,
            anchorDate: interval.end,
            intervalComponents: .init(day: 1)
        )
        
        do {
            let weights = try await weightQuery.result(for: store)
            
            return weights.statistics().map {
                .init(date: $0.startDate, value: $0.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
            }
        } catch HKError.errorNoData {
            throw STError.noData
        } catch {
            throw STError.unableToCompleteRequest
        }
    } 
}
