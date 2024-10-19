//
//  ChartHelper.swift
//  Steps
//
//  Created by christian on 10/19/24.
//

import Foundation

struct ChartHelper {
    // Convert an array of HealthMetric to an array of DateValueChartData
    static func convert(data: [HealthMetric]) -> [DateValueChartData] {
        data.map { .init(date: $0.date, value: $0.value)}
    }
    
    // Calculate the average value for a provided array of chart data
    static func averageValue(for data: [DateValueChartData]) -> Double {
        guard !data.isEmpty else { return 0 }
        
        let totalSteps = data.reduce(0) { $0 + $1.value}
        return totalSteps / Double(data.count)
    }
    
    // Find the first entry in an array whose date matches the selected date
    static func parseSelectedData(from data: [DateValueChartData], in selectedDate: Date?) -> DateValueChartData? {
        guard let selectedDate else { return nil }
        
        return data.first {
            Calendar.current.isDate(selectedDate, inSameDayAs: $0.date)
        }
    }
}
