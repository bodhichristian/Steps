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
            
            LabeledContent {
                Text(data.value, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            } label: {
                Text(data.date, format: .dateTime.month().day().year())
                    .accessibilityLabel(data.date.accessibilityDate)
            }
            .accessibilityElement(children: .combine)
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
                LabeledContent(metric.title) {
                    TextField("Value", text: $inputValue)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                        .frame(alignment: .trailing)
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
                        addData()
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
    
    private func addData() {
        guard let value = Double(inputValue) else {
            writeError = .invalidInputValue
            showingAlert = true
            inputValue = ""
            return
        }
        Task {
            do {
                if metric == .steps {
                    try await hkService.addStepData(for: date, value: value)
                    hkService.stepData = try await hkService.fetchStepCount()
                    isAddingData = false
                } else {
                    try await hkService.addWeightData(for: date, value: Double(inputValue)!)
                    async let weights = hkService.fetchWeights(daysBack: 28)
                    async let weightDiffs = hkService.fetchWeights(daysBack: 29)
                    
                    hkService.weightData = try await weights
                    hkService.weightDiffData = try await weightDiffs
                }
                
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

#Preview {
    NavigationStack {
        HealthDataListView(metric: .steps)
            .environment(HealthKitService())
    }
}
