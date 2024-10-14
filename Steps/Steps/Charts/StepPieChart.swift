
//  StepPieChart.swift
//  Steps
//
//  Created by christian on 8/14/24.
//

import SwiftUI
import Charts

struct StepPieChart: View {
    var chartData: [WeekdayChartData]
    
    var selectedWeekday: WeekdayChartData? {
        guard let rawSelectedChartValue else { return nil }

        var total = 0.0
        return chartData.first {
            total += $0.value
            return rawSelectedChartValue <= total
        }
    }
    
    @State private var rawSelectedChartValue: Double?
    @State private var selectedDay: Date?
    
    var body: some View {
        VStack(alignment: .leading) {
            // Card Header
            HStack {
                VStack(alignment: .leading) {
                    Label("Daily Averages", systemImage: "calendar")
                        .font(.title3.bold())
                        .foregroundStyle(.pink)
                    
                    Text("Last 28 Days")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom, 12)
            
            if chartData.isEmpty {
                ChartDataUnavailableView(
                    symbolName: "chart.bar",
                    title: "No Data",
                    description: "There is no step data from the health app."
                )

            } else {
                // Card Body
                Chart {
                    ForEach(chartData) { weekday in
                        SectorMark(
                            angle: .value("Average Steps", weekday.value),
                            innerRadius: .ratio(0.618),
                            outerRadius: selectedWeekday?.date.weekdayInt == weekday.date.weekdayInt ? 140 : 110,
                            angularInset: 1
                        )
                        .foregroundStyle(.pink.gradient)
                        .cornerRadius(6)
                        .opacity(selectedWeekday == nil ? 1.0 : selectedWeekday?.date.weekdayInt == weekday.date.weekdayInt ? 1.0 : 0.3)
                    }
                }
                .chartAngleSelection(value: $rawSelectedChartValue.animation(.easeInOut))
                .chartLegend(.hidden)
                .frame(height: 240)
                .chartBackground { proxy in
                    GeometryReader { geo in
                        if let plotFrame = proxy.plotFrame {
                            
                            let frame = geo[plotFrame]
                            if let selectedWeekday {
                                VStack(alignment: .center) {
                                    Text(selectedWeekday.date.weekdayTitle)
                                        .font(.title3.bold())
                                        .contentTransition(.numericText())
                                    
                                    Text("\(Int(selectedWeekday.value))")
                                        .fontWeight(.medium)
                                        .foregroundStyle(.secondary)
                                        .contentTransition(.numericText())
                                }
                                .position(x: frame.midX, y: frame.midY)
                            } else {
                                Text("Select a day")
                                    .foregroundStyle(.secondary)
                                    .position(x: frame.midX, y: frame.midY)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color(.secondarySystemBackground))
        }
        .sensoryFeedback(.selection, trigger: selectedDay)
        .onChange(of: selectedWeekday) { oldValue, newValue in
            guard let oldValue, let newValue else { return }
            if oldValue.date.weekdayInt != newValue.date.weekdayInt {
                selectedDay = newValue.date
            }
        }
    }
}

#Preview {
    StepPieChart(chartData: ChartMath.averageWeekdayCount(for: [])) // Replace empty array with MockData.steps to preview working chart
}

