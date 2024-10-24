//
//  ChartHelper.swift
//  Steps
//
//  Created by christian on 10/24/24.
//

import Foundation
import Algorithms

struct ChartHelper {
    static func convert(data: [HealthMetric]) -> [DateValueChartData] {
        data.map { .init(date: $0.date, value: $0.value)}
    }

    static func averageValue(for data: [DateValueChartData]) -> Double {
        guard !data.isEmpty else { return 0 }
        let totalSteps = data.reduce(0) { $0 + $1.value }
        return totalSteps/Double(data.count)
    }

    static func parseSelectedData(from data: [DateValueChartData], in selectedDate: Date?) -> DateValueChartData? {
        guard let selectedDate else { return nil }
        return data.first {
            Calendar.current.isDate(selectedDate, inSameDayAs: $0.date)
        }
    }
    
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
