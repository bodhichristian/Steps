//
//  StepBarChart.swift
//  Steps
//
//  Created by christian on 8/8/24.
//

import SwiftUI
import Charts

struct StepBarChart: View {
    var chartData: [DateValueChartData]
    
    private var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in: rawSelectedDate)
    }
    
    private var config: ChartContainerConfiguration {
        .init(
            title: "Steps",
            symbol: "figure.walk",
            subtitle: "Avg: \(Int(ChartHelper.averageValue(for: chartData))) Steps",
            context: .steps,
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
                    description: "There is no step data from the health app."
                )
                
            } else {
                Chart {
                    if let selectedData {
                        RuleMark(x: .value("Selected Metric", selectedData.date, unit: .day))
                            .foregroundStyle(.secondary.opacity(0.3))
                            .offset(y: -5)
                            .annotation(
                                position: .top,
                                spacing: 0,
                                overflowResolution: .init(x: .fit(to:.chart), y: .disabled)) {
                                    AnnotationView(data: selectedData, context: .steps)
                                }
                    }
                    
                    RuleMark(y: .value("Average", ChartHelper.averageValue(for: chartData)))
                        .foregroundStyle(.secondary)
                        .lineStyle(.init(lineWidth: 1, dash: [5]))
                    
                    ForEach(chartData) { data in
                        BarMark(
                            x: .value("Date", data.date, unit: .day),
                            y: .value("Steps", data.value)
                        )
                        .foregroundStyle(.pink.gradient)
                        .opacity(rawSelectedDate == nil || data.date == selectedData?.date ? 1.0 : 0.3)
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
    StepBarChart(chartData: ChartHelper.convert(data: MockData.steps)) // use MockData.steps for chartData arg when looking to preview mock data
}
