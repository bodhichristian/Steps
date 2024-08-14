//
//  ChartMath.swift
//  Steps
//
//  Created by christian on 8/8/24.
//

import Foundation
import Algorithms

struct ChartMath {
    
    static func averageWeekdayCount(for metric: [HealthMetric]) -> [WeekdayChartData] {
        
        let sortedByWeekday = metric.sorted { $0.date.weekdayInt < $1.date.weekdayInt }
        let weekdayArray = sortedByWeekday.chunked {$0.date.weekdayInt == $1.date.weekdayInt }
        
        var weekdayChartData: [WeekdayChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let averageSteps = total / Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: averageSteps))
        }
        
        for metric in sortedByWeekday {
            print("Day: \(metric.date.weekdayInt), value: \(metric.value)")
        }
        
        print("--------------------------")
        
        for day in weekdayChartData {
            print("Day: \(day.date.weekdayInt), value: \(day.value)")
        }

        return weekdayChartData
    }
}
