//
//  HealthDataListView.swift
//  Steps
//
//  Created by christian on 7/14/24.
//

import SwiftUI

struct HealthDataListView: View {
    @Environment(HealthKitService.self) private var hkService
    @State private var isAddingData: Bool = false
    @State private var date: Date = .now
    @State private var inputValue: String = ""
    
    var metric: HealthMetricContext
    
    var listData: [HealthMetric] {
        metric == .steps ? hkService.stepData : hkService.weightData
    }
    var body: some View {
        List(listData.reversed()) { data in
            HStack {
                Text(data.date, format: .dateTime.month().day().year())
                
                Spacer()
                
                Text(data.value, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
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
                        Task {
                            if metric == .steps {
                                do {
                                    try await hkService.addStepData(for: date, value: Double(inputValue)!)
                                    try await hkService.fetchStepCount()
                                    isAddingData = false
                                } catch STError.sharingDenied(let quantityType) {
                                    print("❌ sharing denied for \(quantityType)")
                                } catch {
                                    print("❌ Data List View unable to complet request")
                                }
                            } else {
                                do {
                                    try await hkService.addWeightData(for: date, value: Double(inputValue)!)
                                    try await hkService.fetchWeights()
                                    try await hkService.fetchWeightForDifferentials()
                                    isAddingData = false
                                } catch STError.sharingDenied(let quantityType) {
                                    print("❌ sharing denied for \(quantityType)")
                                } catch {
                                    print("❌ Data List View unable to complet request")
                                }
                            }
                            
                            isAddingData = false
                        }
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
            .environment(HealthKitService())
    }
}
