//
//  HealthMetric.swift
//  Steps
//
//  Created by christian on 7/18/24.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
