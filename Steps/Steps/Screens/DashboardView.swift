//
//  ContentView.swift
//  Steps
//
//  Created by christian on 7/14/24.
//

import SwiftUI
import Charts

struct DashboardView: View {
    
    @Environment(HealthKitService.self) var hkService
    @State private var showingPrimer = false
    @State private var selectedStat: HealthMetricContext = .steps
    @State private var showingAlert = false
    @State private var fetchError: STError = .noData
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Picker("Selected Stat", selection: $selectedStat) {
                        ForEach(HealthMetricContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    switch selectedStat {
                    case .steps:
                        StepBarChart(
                            selectedStat: selectedStat,
                            chartData: hkService.stepData
                        )
                        StepPieChart(
                            chartData: ChartMath.averageWeekdayCount(for: hkService.stepData)
                        )
                    case .weight:
                        WeightLineChart(
                            selectedStat: selectedStat,
                            chartData: hkService.weightData
                        )
                        WeightDiffBarChart(
                            selectedStat: selectedStat,
                            chartData: ChartMath.averageDailyWeightDiffs(for: hkService.weightDiffData)
                        )
                    }
                }
            }
            .padding()
            .task {
                fetchHealthData()
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDataListView(metric: metric)
            }
            .alert(isPresented: $showingAlert, error: fetchError) { fetchError in
                // Action
            } message: { fetchError in
                Text(fetchError.failureReason)
            }
            .sheet(isPresented: $showingPrimer) {
                // When user allows Health access, fetch health data
                fetchHealthData()
            } content: {
                HKPermissionPrimerView()
            }
            .tint(selectedStat == .steps ? .pink : .indigo)
            
        }
    }
    
    private func fetchHealthData() {
        Task {
            do {
                // Uncomment below line to add sample data to Health app on simulator
                // await hkService.addSampleData()
                                 
                async let steps = hkService.fetchStepCount()
                async let weights = hkService.fetchWeights(daysBack: 28)
                async let weightDiffs = hkService.fetchWeights(daysBack: 29)
                
                let results = try await (steps, weights, weightDiffs)
                
                hkService.stepData = results.0
                hkService.weightData = results.1
                hkService.weightDiffData = results.2
            } catch STError.authNotDetermined {
                showingPrimer = true
            } catch STError.noData {
                fetchError = .noData
                showingAlert = true
            } catch {
                fetchError = .unableToCompleteRequest
                showingAlert = true
            }
        }
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitService())
}
