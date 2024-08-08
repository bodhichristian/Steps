//
//  StepBarChart.swift
//  Steps
//
//  Created by christian on 8/8/24.
//

import SwiftUI
import Charts

struct StepBarChart: View {
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetric]
    
    var averageStepCount: Double {
        guard !chartData.isEmpty else { return 0 }
        
        let totalSteps = chartData.reduce(0) { $0 + $1.value}
        return totalSteps / Double(chartData.count)
    }
    
    var selectedHealthMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }

        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    @State private var rawSelectedDate: Date?

    var body: some View {
        // Steps Card
        VStack(alignment: .leading) {
            // Card Header
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Steps", systemImage: "figure.walk")
                            .font(.title3.bold())
                            .foregroundStyle(.pink)
                        
                        Text("Avg: \(Int(averageStepCount)) Steps")
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
                                annotationView
                            }
                }
                
                RuleMark(y: .value("Average", averageStepCount))
                    .foregroundStyle(.secondary)
                    .lineStyle(.init(lineWidth: 1, dash: [5]))
                
                ForEach(chartData) { data in
                    BarMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value("Steps", data.value)
                    )
                    .foregroundStyle(.pink.gradient)
                    .opacity(rawSelectedDate == nil || data.date == selectedHealthMetric?.date ? 1.0 : 0.3)
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
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color(.secondarySystemBackground))
        }
    }
    
    private var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedHealthMetric?.date ?? .now, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(Int(selectedHealthMetric?.value ?? 0), format: .number)
                .fontWeight(.heavy)
                .foregroundStyle(.pink)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        }
    }
}

#Preview {
    StepBarChart(selectedStat: .steps, chartData: HealthMetric.mockData)
}
