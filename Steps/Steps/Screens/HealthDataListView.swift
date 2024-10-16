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
    @State private var showingAlert: Bool = false
    @State private var writeError: STError = .noData
    
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
            .alert(isPresented: $showingAlert, error: writeError) { writeError in
                switch writeError {
                case .authNotDetermined, .noData, .unableToCompleteRequest, .invalidInputValue:
                    EmptyView()
                case .sharingDenied(_):
                    Button("Settings") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    
                    Button("Cancel", role: .cancel) { }
                }
            } message: { writeError in
                Text(writeError.failureReason)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        guard let value = Double(inputValue) else {
                            writeError = .invalidInputValue
                            showingAlert = true
                            inputValue = ""
                            return
                        }
                        Task {
                            if metric == .steps {
                                do {
                                    try await hkService.addStepData(for: date, value: value)
                                    try await hkService.fetchStepCount()
                                    isAddingData = false
                                } catch STError.sharingDenied(let quantityType) {
                                    writeError = .sharingDenied(quantityType: quantityType)
                                    showingAlert = true
                                } catch {
                                    writeError = .unableToCompleteRequest
                                    showingAlert = true
                                }
                                
                            } else {
                                do {
                                    try await hkService.addWeightData(for: date, value: Double(inputValue)!)
                                    try await hkService.fetchWeights()
                                    try await hkService.fetchWeightForDifferentials()
                                    isAddingData = false
                                } catch STError.sharingDenied(let quantityType) {
                                    writeError = .sharingDenied(quantityType: quantityType)
                                    showingAlert = true
                                } catch {
                                    writeError = .unableToCompleteRequest
                                    showingAlert = true
                                }
                            }
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
