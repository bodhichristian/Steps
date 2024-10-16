//
//  ChartDataTypes.swift
//  Steps
//
//  Created by christian on 8/8/24.
//

import Foundation

struct WeekdayChartData: Equatable,Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
