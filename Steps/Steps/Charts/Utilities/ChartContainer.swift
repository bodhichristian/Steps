//
//  ChartContainer.swift
//  Steps
//
//  Created by christian on 10/24/24.
//

import SwiftUI

struct ChartContainer<Content: View>: View {
    let chartType: ChartType
    
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading) {
            if chartType.isNav {
                navigationLinkView
            } else {
                titleView
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
            }

            content()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }

    var navigationLinkView: some View {
        NavigationLink(value: chartType.context) {
            HStack {
                titleView
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(.secondary)
        .padding(.bottom, 12)
    }

    var titleView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Label(chartType.title, systemImage: chartType.symbol)
                .font(.title3.bold())
                .foregroundStyle(chartType.context == .steps ? .pink : .indigo)
                .frame(height: 30, alignment: .top)

            Text(chartType.subtitle)
                .font(.caption)
        }
    }
}

#Preview {
    ChartContainer(chartType: .stepWeekdayPie) {
        Text("Chart Goes Here")
            .frame(minHeight: 150)
    }
}
