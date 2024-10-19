//
//  ChartContainer.swift
//  Steps
//
//  Created by christian on 10/16/24.
//

import SwiftUI

struct ChartContainer<Content: View>: View {
    
    let title: String
    let symbol: String
    let subtitle: String
    let context: HealthMetricContext
    let isNav: Bool
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            // Card Header
            if isNav {
                navHeaderView
            } else {
                titleView
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
            }
            content()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color(.secondarySystemBackground))
        }
    }
    
    private var navHeaderView: some View {
        NavigationLink(value: context) {
            HStack {
                titleView
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(.secondary)
        .padding(.bottom, 12)
    }
    
    private var titleView: some View {
        VStack(alignment: .leading) {
            Label(title, systemImage: symbol)
                .font(.title3.bold())
                .foregroundStyle(context == .steps ? .pink : .indigo)
            
            Text(subtitle)
                .font(.caption)
        }
    }
}

#Preview {
    ChartContainer(
        title: "Test title",
        symbol: "figure.walk",
        subtitle: "Test subtitle",
        context: .steps,
        isNav: true
    ) {
        Text("Chart goes here.").frame(
            height: 150
        )
    }
}
