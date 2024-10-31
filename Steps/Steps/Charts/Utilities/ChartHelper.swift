//
//  ChartHelper.swift
//  Steps
//
//  Created by christian on 10/24/24.
//

import Foundation
import Algorithms

struct ChartHelper {
    /// Convert an array of ``HealthMetric`` to an array of ``DateValueChartData`` for ease of use in a SwiftUI Chart.
    ///
    /// - Parameter data: An array of step, weight, or other type of HealthKit data
    /// - Returns: Array of DateValueChartData
    static func convert(data: [HealthMetric]) -> [DateValueChartData] {
        data.map { .init(date: $0.date, value: $0.value)}
    }
    
    /// Find the first piece of ``DateValueChartData`` whose date matches the provided date.
    /// - Parameters:
    ///   - data: An array of ``DateValueChartData``
    ///   - selectedDate: Date to compare against array of data
    /// - Returns: An optional DateValueChartData
    static func parseSelectedData(from data: [DateValueChartData], in selectedDate: Date?) -> DateValueChartData? {
        guard let selectedDate else { return nil }
        return data.first {
            Calendar.current.isDate(selectedDate, inSameDayAs: $0.date)
        }
    }
    
    /// Get average values from a collection of HealthKit data, grouped by day of the week.
    ///
    ///  Uses a single digit representation of the day of the week to group data by weekday. Calculates the averages of each of the chunks (weekdays).
    /// - Parameter metric: An array of ``HealthMetric`` steps
    /// - Returns: An array of DateValueChartData
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
    
    /// Get average differences in weight from day to day.
    ///
    ///  Uses a single digit representation of the day of the week to group data by weekday. Calculates the averages of each of the chunks (weekdays).
    /// - Parameter metric: An array of ``HealthMetric`` weights
    /// - Returns: An array of DateValueChartData
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
