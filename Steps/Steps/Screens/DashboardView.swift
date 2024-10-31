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
                        StepBarChart(chartData: ChartHelper.convert(data: hkService.stepData))
                        StepPieChart(chartData: ChartHelper.averageWeekdayCount(for: hkService.stepData))
                    case .weight:
                        WeightLineChart(chartData: ChartHelper.convert(data: hkService.weightData))
                        WeightDiffBarChart(chartData: ChartHelper.averageDailyWeightDiffs(for: hkService.weightDiffData))
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
            .fullScreenCover(isPresented: $showingPrimer) {
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
                async let steps = hkService.fetchStepCount()
                async let weights = hkService.fetchWeights(daysBack: 28)
                async let weightDiffs = hkService.fetchWeights(daysBack: 29)
                
                hkService.stepData = try await steps
                hkService.weightData = try await weights
                hkService.weightDiffData = try await weightDiffs
                
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
