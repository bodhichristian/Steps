//
//  WeightLineChart.swift
//  Steps
//
//  Created by christian on 8/15/24.
//

import SwiftUI
import Charts

struct WeightLineChart: View {
    var chartData: [DateValueChartData]
    
    var minValue: Double {
        chartData.map { $0.value }.min() ?? 0
    }
    
    private var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in: rawSelectedDate)
    }
    
    private var config: ChartContainerConfiguration {
        .init(
            title: "Weight",
            symbol: "figure",
            subtitle: "Avg: 175 lbs",
            context: .weight,
            isNav: true)
    }
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
    
    var body: some View {
        ChartContainer(config: config) {
            if chartData.isEmpty {
                ChartDataUnavailableView(
                    symbolName: "chart.line.downtrend.xyaxis",
                    title: "No Data",
                    description: "There is no step count data available from the Health App."
                )
            } else {
                Chart {
                    if let selectedData {
                        ChartAnnotation(data: selectedData, context: .weight)
                    }
                    
                    RuleMark(y: .value("Goal", 167)) // Replace with user choice
                        .foregroundStyle(.mint)
                        .lineStyle(.init(lineWidth: 1, dash: [5]))
                    
                    ForEach(chartData) { weight in
                        AreaMark(
                            x: .value("Day", weight.date, unit: .day),
                            yStart: .value("Value", weight.value),
                            yEnd: .value("Min Value", minValue) // end value ensures gradient does not draw below chart
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.indigo.opacity(0.8), .indigo.opacity(0.0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        
                        LineMark(
                            x: .value("Day", weight.date, unit: .day),
                            y: .value(
                                "Value",
                                weight.value
                            )
                        )
                        .foregroundStyle(.indigo)
                        .symbol(.circle) //                    .interpolationMethod(.catmullRom) is overridden by symbol modifier
                    }
                }
                .frame(height: 150)
                .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
                .chartYScale(domain: .automatic(includesZero: false))
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                            .foregroundStyle(.gray.opacity(0.3))
                        
                        AxisValueLabel()
                    }
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selectedDay)
        .onChange(of: rawSelectedDate) { oldValue, newValue in
            if let newValue {
                if oldValue?.weekdayInt != newValue.weekdayInt {
                    selectedDay = newValue
                }
            }
        }
    }
    
    
}

#Preview {
    WeightLineChart(chartData: ChartHelper.convert(data: MockData.weights))
}
