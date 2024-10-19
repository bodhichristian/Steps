//
//  AnnotationView.swift
//  Steps
//
//  Created by christian on 8/15/24.
//

import SwiftUI

struct AnnotationView: View {
    let data: DateValueChartData
    let context: HealthMetricContext
    
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
                // Verbose label
                Text(data.date, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                    .font(.footnote.bold())
                    .foregroundStyle(.secondary)
                
                // Value
                Text(data.value, format: .number.precision(.fractionLength(context == .weight ? 1 : 0)))
                    .fontWeight(.heavy)
                    .foregroundStyle(accentColor)
               
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
    AnnotationView(data: .init(date: .now, value: 100), context: .weight)
}
