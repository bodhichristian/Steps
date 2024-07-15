//
//  HealthDataListView.swift
//  Steps
//
//  Created by christian on 7/14/24.
//

import SwiftUI

struct HealthDataListView: View {
    
    var metric: HealthMetricContext
    
    @State private var isAddingData: Bool = false
    @State private var date: Date = .now
    @State private var inputValue: String = ""
    
    var body: some View {
        List(0..<28) { i in
            HStack {
                Text(Date(), format: .dateTime.month().day().year())
                Spacer()
                Text(10000, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            }
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isAddingData) {
            addDataView
        }
        .toolbar {
            Button("Add Data", systemImage: "plus") {
                isAddingData = true
            }
        }
    }
    
    private var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                HStack {
                    Text(metric.title)
                    Spacer()
                    TextField("Value", text: $inputValue)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 200)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add data") {
                        //
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isAddingData = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataListView(metric: .steps)
    }
}
