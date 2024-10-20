//
//  WeightBarChart.swift
//  Steps
//
//  Created by christian on 8/15/24.
//

import SwiftUI
import Charts

struct WeightDiffBarChart: View {
    var chartData: [DateValueChartData]
    
    private var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in: rawSelectedDate)
    }
    
    private var config: ChartContainerConfiguration {
        .init(
            title: "Weight",
            symbol: "calendar",
            subtitle: "Last 28 Days",
            context: .weight,
            isNav: true
        )
    }
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
    
    var body: some View {
        ChartContainer(config: config) {
            if chartData.isEmpty {
                ChartDataUnavailableView(
                    symbolName: "chart.bar",
                    title: "No Data",
                    description: "There is no weight data available from the Health app."
                )
            } else {
                Chart {
                    if let selectedData {
                        ChartAnnotation(data: selectedData, context: .weight)
                    }
                    
                    ForEach(chartData) { weightDiff in
                        BarMark(
                            x: .value("Date", weightDiff.date, unit: .day),
                            y: .value("Weight Diff", weightDiff.value)
                        )
                        .foregroundStyle((weightDiff.value > 0 ) ? Color.indigo.gradient : Color.mint.gradient)
                        .opacity(rawSelectedDate == nil || weightDiff.date == selectedData?.date ? 1.0 : 0.3)
                    }
                }
                .frame(height: 240)
                .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) {
                        AxisValueLabel(format: .dateTime.weekday(), centered: true)
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                            .foregroundStyle(.gray.opacity(0.3))
                        
                        AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)) )
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
    WeightDiffBarChart(chartData: MockData.weightDiffs) // Replace empty array with MockData.weightDiffs to preview chart
}
