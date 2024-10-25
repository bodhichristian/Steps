//
//  StepBarChart.swift
//  Steps
//
//  Created by christian on 8/8/24.
//

import SwiftUI
import Charts

struct StepBarChart: View {
    let chartData: [DateValueChartData]

    private var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in:  rawSelectedDate)
    }
    
    private var averageSteps: Int {
        Int(chartData.map { $0.value }.average)
    }
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?

    var body: some View {
        ChartContainer(chartType: .stepBar(average: averageSteps)) {
            if chartData.isEmpty {
                ChartDataUnavailableView(
                    symbolName: "chart.bar",
                    title: "No Data",
                    description: "There is no step count data from the Health app."
                )
            } else {
                Chart {
                    if let selectedData {
                        ChartAnnotationView(data: selectedData, context: .steps)
                    }

                    RuleMark(y: .value("Average", averageSteps))
                        .foregroundStyle(Color.secondary)
                        .lineStyle(.init(lineWidth: 1, dash: [5]))

                    ForEach(chartData) { steps in
                        BarMark(
                            x: .value("Date", steps.date, unit: .day),
                            y: .value("Steps", steps.value)
                        )
                        .foregroundStyle(Color.pink.gradient)
                        .opacity(rawSelectedDate == nil || steps.date == selectedData?.date ? 1.0 : 0.3)
                    }
                }
                .frame(height: 150)
                .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                            .foregroundStyle(Color.secondary.opacity(0.3))

                        AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
                    }
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selectedDay)
        .onChange(of: rawSelectedDate) { oldValue, newValue in
            if oldValue?.weekdayInt != newValue?.weekdayInt {
                selectedDay = newValue
            }
        }
    }
}

#Preview {
    StepBarChart(chartData: [])
}
