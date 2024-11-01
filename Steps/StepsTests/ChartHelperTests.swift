//
//  ChartHelperTests.swift
//  StepsTests
//
//  Created by christian on 10/31/24.
//

import Foundation
import Testing
@testable import Steps

@Suite("Chart Helper Tests")
struct ChartHelperTests {
    
    var metrics: [HealthMetric] = [
        .init(date: Calendar.current.date(from: .init(year: 2024, month: 10, day: 14))!, value: 1000), // Monday
        .init(date: Calendar.current.date(from: .init(year: 2024, month: 10, day: 15))!, value: 500), // Tuesday
        .init(date: Calendar.current.date(from: .init(year: 2024, month: 10, day: 16))!, value: 250), // Wednesday
        .init(date: Calendar.current.date(from: .init(year: 2024, month: 10, day: 21))!, value: 750) // Monday
    ]
    
    @Test func averageWeekdayCount() {
        let averageWeekdayCount = ChartHelper.averageWeekdayCount(for: metrics)
        #expect(averageWeekdayCount.count == 3)
        #expect(averageWeekdayCount[0].value == 875)
        #expect(averageWeekdayCount[1].value == 500)
        #expect(averageWeekdayCount[2].date.weekdayTitle == "Wednesday")
    }
}
