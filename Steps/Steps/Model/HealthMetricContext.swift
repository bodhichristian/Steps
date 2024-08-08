//
//  HealthMetricContext.swift
//  Steps
//
//  Created by christian on 8/8/24.
//

import Foundation

enum HealthMetricContext: CaseIterable, Identifiable {
    case steps, weight
    var id: Self { self }
    
    var title: String {
        switch self {
        case .steps:
            "Steps"
        case .weight:
            "Weight"
        }
    }
}
