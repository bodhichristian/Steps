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
    @Environment(HealthKitData.self) var hkData
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
                        StepBarChart(chartData: ChartHelper.convert(data: hkData.steps))
                        StepPieChart(chartData: ChartHelper.averageWeekdayCount(for: hkData.steps))
                    case .weight:
                        WeightLineChart(chartData: ChartHelper.convert(data: hkData.weights))
                        WeightDiffBarChart(chartData: ChartHelper.averageDailyWeightDiffs(for: hkData.weightDiffs))
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
                
                hkData.steps = try await steps
                hkData.weights = try await weights
                hkData.weightDiffs = try await weightDiffs
                
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
