//
//  ContentView.swift
//  Steps
//
//  Created by christian on 7/14/24.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @AppStorage("permissionPrimed") private var permissionPrimed = false
    
    @Environment(HealthKitService.self) var hkService
    @State private var showingPrimer = false
    @State private var selectedStat: HealthMetricContext = .steps
    
    var stepsSelected: Bool {
        selectedStat == .steps
    }
    
    var body: some View {
        NavigationStack{
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
                        StepBarChart(selectedStat: selectedStat, chartData: hkService.stepData)
                        StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkService.stepData))
                    case .weight:
                        WeightLineChart(selectedStat: selectedStat, chartData: hkService.weightData)
                    }
                }
            }
            .padding()
            .task {
                //await hkService.addSampleData()
                await hkService.fetchStepCount()
                await hkService.fetchWeights()
                // if user has not been primed, showingPrimer will be set to true
                // and a permission priming sheet will be presented.
                showingPrimer = !permissionPrimed
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDataListView(metric: metric)
            }
            .sheet(isPresented: $showingPrimer) {
                // fetch health data
            } content: {
                HKPermissionPrimerView(permissionPrimed: $permissionPrimed)
            }
        }
        .tint(stepsSelected ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitService())
}
