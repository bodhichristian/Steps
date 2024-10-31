//
//  AnnotationView.swift
//  Steps
//
//  Created by christian on 8/15/24.
//

import SwiftUI
import Charts

struct ChartAnnotationView: ChartContent {
    let data: DateValueChartData
    let context: HealthMetricContext
    
    var body: some ChartContent {
        RuleMark(x: .value("Selected Metric", data.date, unit: .day))
            .foregroundStyle(Color.secondary.opacity(0.3))
            .offset(y: -10)
            .annotation(
                position: .top,
                spacing: 0,
                overflowResolution: .init(x: .fit(to: .chart), y: .disabled)
            ) {
                VStack(alignment: .leading) {
                    dateLabel
                        .font(.footnote.bold())
                        .foregroundStyle(.secondary)

                    valueLabel
                        .fontWeight(.heavy)
                        .foregroundStyle(context == .steps ? .pink : .indigo)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.secondarySystemBackground))
                        .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
                )
            }
    }
    
    private var dateLabel: some View {
        Text(data.date, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
    }
    
    private var valueLabel: some View {
        Text(data.value, format: .number.precision(.fractionLength(context == .steps ? 0 : 1)))
    }
}


