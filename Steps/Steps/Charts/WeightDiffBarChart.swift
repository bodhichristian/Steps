//
//  WeightBarChart.swift
//  Steps
//
//  Created by christian on 8/15/24.
//

import SwiftUI
import Charts

struct WeightDiffBarChart: View {
    var selectedStat: HealthMetricContext
    var chartData: [WeekdayChartData]
    
    var selectedData: WeekdayChartData? {
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
                HStack {
                    VStack(alignment: .leading) {
                        Label("Average Daily Change", systemImage: "calendar.circle")
                            .font(.title3.bold())
                            .foregroundStyle(.indigo)
                        
                        Text("Last 28 Days")
                            .font(.caption)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 12)
            .foregroundStyle(.secondary)
            
            Chart {
                if let selectedData {
                    RuleMark(x: .value("Selected Metric", selectedData.date, unit: .day))
                        .foregroundStyle(.secondary.opacity(0.3))
                        .offset(y: -5)
                        .annotation(
                            position: .top,
                            spacing: 0,
                            overflowResolution: .init(x: .fit(to:.chart), y: .disabled)) {
                                AnnotationView(weekdayChartData: selectedData, context: selectedStat)
                            }
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
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color(.secondarySystemBackground))
        }

    }
}

#Preview {
    WeightDiffBarChart(selectedStat: .weight, chartData: MockData.weightDiffs)
}
