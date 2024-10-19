//
//  ChartMath.swift
//  Steps
//
//  Created by christian on 8/8/24.
//

import Foundation
import Algorithms

struct ChartMath {
    
    static func averageWeekdayCount(for metric: [HealthMetric]) -> [DateValueChartData] {
        
        let sortedByWeekday = metric.sorted { $0.date.weekdayInt < $1.date.weekdayInt }
        let weekdayArray = sortedByWeekday.chunked {$0.date.weekdayInt == $1.date.weekdayInt }
        
        var weekdayChartData: [DateValueChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let averageSteps = total / Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: averageSteps))
        }
        
        return weekdayChartData
    }
    
    static func averageDailyWeightDiffs(for weights: [HealthMetric]) ->[DateValueChartData] {
        var diffValues: [(date: Date, value: Double)] = []
        
        guard weights.count > 1 else { return [] }
        
        for i in 1..<weights.count {
            let date = weights[i].date
            let diff = weights[i].value - weights[i - 1].value
            diffValues.append((date: date, value: diff))
        }
        
        let sortedByWeekday = diffValues.sorted { $0.date.weekdayInt < $1.date.weekdayInt }
        let weekdayArray = sortedByWeekday.chunked {$0.date.weekdayInt == $1.date.weekdayInt }
        
        var weekdayChartData: [DateValueChartData] = []
        
        for array in weekdayArray {
            
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let averageWeightDiff = total / Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: averageWeightDiff))
        }
        
        return weekdayChartData
    }
}
