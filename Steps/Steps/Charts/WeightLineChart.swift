//
//  WeightLineChart.swift
//  Steps
//
//  Created by christian on 8/15/24.
//

import SwiftUI
import Charts

struct WeightLineChart: View {
    var selectedStat: HealthMetricContext
    var chartdata: [HealthMetric]
    
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
                ForEach(chartdata) { weight in
                    AreaMark(
                        x: .value("Day", weight.date, unit: .day),
                        y: .value(
                            "Value",
                            weight.value
                        )
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
                }
            }
            .frame(height: 150)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color(.secondarySystemBackground))
        }
    }
}

#Preview {
    WeightLineChart(selectedStat: .weight, chartdata: MockData.weights)
}
