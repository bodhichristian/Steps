//
//  StepPieChart.swift
//  Steps
//
//  Created by christian on 8/14/24.
//

import SwiftUI
import Charts

struct StepPieChart: View {
    
    var chartData: [WeekdayChartData]
    
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
                       angularInset: 1
                    )
                    .foregroundStyle(.pink.gradient)
                    .cornerRadius(6)
                    
                    // Annotation option. Difficult to visually manage on pie chart.
//                    .annotation(position: .overlay) {
//                        Text(weekday.value, format: .number.notation(.compactName))
//                            .foregroundStyle(.white)
//                            .fontWeight(.bold)
//                    }
                    
 
//                    // Create a visual hierarchy based on days of the week
//                    SectorMark(angle: .value("Average Steps", weekday.value))
//                        .foregroundStyle(by: .value("Weekday", weekday.date.weekdayTitle))
                }
            }
            .chartLegend(.hidden)
            .frame(height: 240)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color(.secondarySystemBackground))
        }
    }
}

#Preview {
    StepPieChart(chartData: ChartMath.averageWeekdayCount(for: HealthMetric.mockData))
}
