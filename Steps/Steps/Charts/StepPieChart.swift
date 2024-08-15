//
//  StepPieChart.swift
//  Steps
//
//  Created by christian on 8/14/24.
//

import SwiftUI
import Charts

struct StepPieChart: View {
    @State private var rawSelectedChartValue: Double?
    
    var chartData: [WeekdayChartData]
    
    var selectedWeekday: WeekdayChartData? {
        guard let rawSelectedChartValue else { return nil }

        var total = 0.0
        return chartData.first {
            total += $0.value
            return rawSelectedChartValue <= total
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Card Header
            HStack {
                VStack(alignment: .leading) {
                    Label("Averages", systemImage: "calendar")
                        .font(.title3.bold())
                        .foregroundStyle(.pink)
                    
                    Text("Last 28 Days")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom, 12)
            
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
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color(.secondarySystemBackground))
        }
    }
}

#Preview {
    StepPieChart(chartData: ChartMath.averageWeekdayCount(for: MockData.steps))
}










//                    // Create a visual hierarchy based on days of the week
//                    SectorMark(angle: .value("Average Steps", weekday.value))
//                        .foregroundStyle(by: .value("Weekday", weekday.date.weekdayTitle))

// Annotation option. Difficult to visually manage on pie chart.
//                    .annotation(position: .overlay) {
//                        Text(weekday.value, format: .number.notation(.compactName))
//                            .foregroundStyle(.white)
//                            .fontWeight(.bold)
//                    }
