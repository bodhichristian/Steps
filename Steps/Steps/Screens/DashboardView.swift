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
                    
                    
                    StepBarChart(selectedStat: selectedStat, chartData: hkService.stepData)
                    
                    // Averages Card
                    VStack(alignment: .leading) {
                        // Card Header
                        HStack {
                            VStack(alignment: .leading) {
                                Label("Averages", systemImage: "calendar")
                                    .font(.title3.bold())
                                    .foregroundStyle(.pink)
                                
                                Text("Last 28 Days")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.bottom, 12)
                        
                        // Card Body
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 240)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(Color(.secondarySystemBackground))
                    }
                }
            }
            .padding()
            .task {
                await hkService.fetchStepCount()
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
