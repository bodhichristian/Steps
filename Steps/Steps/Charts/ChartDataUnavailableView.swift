//
//  ChartDataUnavailableView.swift
//  Steps
//
//  Created by christian on 10/14/24.
//

import SwiftUI

struct ChartDataUnavailableView: View {
    let symbolName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack {
            Image(systemName: symbolName)
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.bottom, 8)
            
            Text(title)
                .font(.caption).bold()
            
            Text(description)
                .font(.footnote)
        }
        .foregroundStyle(.secondary)
        .frame(.infinite, alignment: .center)
    }
}

#Preview {
    ChartDataUnavailableView(
        symbolName: "chart.bar",
        title: "No Data",
        description: "There is no step data from the health app."
    )
}
