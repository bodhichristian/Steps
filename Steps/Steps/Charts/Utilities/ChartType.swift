//
//  ChartType.swift
//  Steps
//
//  Created by christian on 10/25/24.
//

import Foundation
import SwiftUI

enum ChartType {
    case stepBar(average: Int)
    case stepWeekdayPie
    case weightLine(average: Double)
    case weightDiffBar
    
    var title: String {
        switch self {
        case .stepBar(_):
            "Steps"
        case .stepWeekdayPie:
            "Averages"
        case .weightLine(_):
            "Weight"
        case .weightDiffBar:
            "Average Daily Change"
        }
    }
    
    var subtitle: String {
        switch self {
        case .stepBar(let average):
            "Avg: \(average) steps"
        case .stepWeekdayPie:
            "Last 28 Days"
        case .weightLine(let average):
            "Avg: \(average.formatted(.number.precision(.fractionLength(1)))) lbs"
        case .weightDiffBar:
            "Last 28 Days"
        }
    }
    
    var symbol: String {
        switch self {
        case .stepBar(_):
            "figure.walk"
        case .stepWeekdayPie:
            "calendar"
        case .weightLine(_):
            "figure"
        case .weightDiffBar:
            "figure"
        }
    }
    
    var context: HealthMetricContext {
        switch self {
        case .stepBar(_), .stepWeekdayPie:
                .steps
        case .weightLine(_), .weightDiffBar:
                .weight
        }
    }
    
    var isNav: Bool {
        switch self {
        case .stepBar, .weightLine(_):
            true
        case .stepWeekdayPie, .weightDiffBar:
            false
        }
    }
}
