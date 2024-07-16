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
}
