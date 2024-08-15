//
//  WeightLineChart.swift
//  Steps
//
//  Created by christian on 8/15/24.
//

import SwiftUI
import Charts

struct WeightLineChart: View {
    @State private var rawSelectedDate: Date?
    
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetric]
    
    var minValue: Double {
        chartData.map { $0.value }.min() ?? 0
    }
    
    var selectedHealthMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        
        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Card Header
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Weight", systemImage: "figure")
                            .font(.title3.bold())
                            .foregroundStyle(.indigo)
                        
                        Text("Avg: 175 lbs")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
                .padding(.bottom, 12)
            }
            .foregroundStyle(.secondary)
            
            Chart {
                if let selectedHealthMetric {
                    RuleMark(x: .value("Selected Metric", selectedHealthMetric.date, unit: .day))
                        .foregroundStyle(.secondary.opacity(0.3))
                        .offset(y: -5)
                        .annotation(
                            position: .top,
                            spacing: 0,
                            overflowResolution: .init(x: .fit(to:.chart), y: .disabled)) {
                                AnnotationView(metric: selectedHealthMetric, context: selectedStat)
                            }
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
                    
                    //.interpolationMethod(.catmullRom)
                    LineMark(
                        x: .value("Day", weight.date, unit: .day),
                        y: .value(
                            "Value",
                            weight.value
                        )
                    )
                    .foregroundStyle(.indigo)
//                    .interpolationMethod(.catmullRom) // overridden by symbol modifier
                    .symbol(.circle)
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
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color(.secondarySystemBackground))
        }
    }
}

#Preview {
    WeightLineChart(selectedStat: .weight, chartData: MockData.weights)
}
