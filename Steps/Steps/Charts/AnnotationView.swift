//
//  AnnotationView.swift
//  Steps
//
//  Created by christian on 8/15/24.
//

import SwiftUI

struct AnnotationView: View {
    var metric: HealthMetric?
    var weekdayChartData: WeekdayChartData?
    var context: HealthMetricContext?
    
    var accentColor: Color {
        switch context {
        case .weight:
                .indigo
        default:
                .pink
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let weekdayChartData {
                // Verbose label
                Text(weekdayChartData.date, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                    .font(.footnote.bold())
                    .foregroundStyle(.secondary)
                
                // Value
                Text(weekdayChartData.value, format: .number.precision(.fractionLength(context == .weight ? 1 : 0)))
                    .fontWeight(.heavy)
                    .foregroundStyle(weekdayChartData.value > 0 ?  accentColor : .mint)
            }
            else {
                Text(metric?.date ?? .now, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                    .font(.footnote.bold())
                    .foregroundStyle(.secondary)
                
                Text(metric?.value ?? 0, format: .number.precision(.fractionLength(context == .weight ? 1 : 0)))
                    .fontWeight(.heavy)
                    .foregroundStyle(accentColor)
            }
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
    AnnotationView(context: .weight)
}
