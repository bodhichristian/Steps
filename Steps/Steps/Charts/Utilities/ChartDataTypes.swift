//
//  ChartDataTypes.swift
//  Steps
//
//  Created by christian on 8/8/24.
//

import Foundation

struct DateValueChartData: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
}
