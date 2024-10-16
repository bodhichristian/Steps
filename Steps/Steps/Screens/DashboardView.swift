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
    
    var stepsSelected: Bool {
        selectedStat == .steps
    }
    
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
                do {
                    //await hkService.addSampleData()
                    try await hkService.fetchStepCount()
                    try await hkService.fetchWeights()
                    try await hkService.fetchWeightForDifferentials()
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
                // fetch health data
            } content: {
                HKPermissionPrimerView()
            }
            .tint(stepsSelected ? .pink : .indigo)
            
        }
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitService())
}
