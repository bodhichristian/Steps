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
    
//    func addSampleData() async {
//        var sampleData: [HKQuantitySample] = []
//        
//        for i in 0...28 {
//            let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4_000...20_000))
//            let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: 160 + Double(i/3)...165 + Double(i/3)))
//            
//            let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now)!
//            let endDate = Calendar.current.date(byAdding: .minute, value: .random(in: 120...3600), to: startDate)!
//            
//            let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: startDate, end: endDate)
//            let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass),quantity: weightQuantity,start: startDate,end: endDate)
//            
//            sampleData.append(stepSample)
//            sampleData.append(weightSample)
//        }
//        
//        try! await store.save(sampleData)
//        print("✅ Sample data added.")
//    }
}
