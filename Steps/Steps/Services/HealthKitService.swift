//
//  HKService.swift
//  Steps
//
//  Created by christian on 7/15/24.
//

import Foundation
import HealthKit
import Observation

@Observable
class HealthKitService {
    
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
    
    var stepData: [HealthMetric] = []
    var weightData: [HealthMetric] = []
    
    func fetchStepCount() async {
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.stepCount), predicate: queryPredicate)
        
        let stepsQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: samplePredicate,
            options: .cumulativeSum,
            anchorDate: endDate,
            intervalComponents: .init(day: 1)
        )
        
        do {
            let stepCounts = try await stepsQuery.result(for: store)
            
            stepData = stepCounts.statistics().map {
                .init(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            }
        } catch {
            // handle error
        }
    }
    
    func fetchWeights() async {
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.bodyMass), predicate: queryPredicate)
        
        let weightQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: samplePredicate,
            options: .mostRecent,
            anchorDate: endDate,
            intervalComponents: .init(day: 1)
        )
        
        do {
            let weights = try await weightQuery.result(for: store)
            
            weightData = weights.statistics().map {
                .init(date: $0.startDate, value: $0.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
            }
        } catch {
            // handle error
        }
    }
    
    
    
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
}
