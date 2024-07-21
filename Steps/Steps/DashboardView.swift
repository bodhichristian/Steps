//
//  ContentView.swift
//  Steps
//
//  Created by christian on 7/14/24.
//

import SwiftUI
import Charts

enum HealthMetricContext: CaseIterable, Identifiable {
    case steps, weight
    var id: Self { self }
    
    var title: String {
        switch self {
        case .steps:
            "Steps"
        case .weight:
            "Weight"
        }
    }
}

struct DashboardView: View {
    
    @AppStorage("permissionPrimed") private var permissionPrimed = false
    
    @Environment(HealthKitService.self) var hkService
    @State private var showingPrimer = false
    @State private var selectedState: HealthMetricContext = .steps
    
    var stepsSelected: Bool {
        selectedState == .steps
    }
    
    var averageStepCount: Double {
        guard !hkService.stepData.isEmpty else { return 0 }
        
        let totalSteps = hkService.stepData.reduce(0) { $0 + $1.value}
        return totalSteps / Double(hkService.stepData.count)
    }
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 20) {
                    
                    Picker("Selected Stat", selection: $selectedState) {
                        ForEach(HealthMetricContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // Steps Card
                    VStack(alignment: .leading) {
                        // Card Header
                        NavigationLink(value: selectedState) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Label("Steps", systemImage: "figure.walk")
                                        .font(.title3.bold())
                                        .foregroundStyle(.pink)
                                    
                                    Text("Avg: \(Int(averageStepCount)) Steps")
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                            .padding(.bottom, 12)
                        }
                        .foregroundStyle(.secondary)
                        
                        Chart {
                            RuleMark(y: .value("Average", averageStepCount))
                                .foregroundStyle(.secondary)
                                .lineStyle(.init(lineWidth: 1, dash: [5]))
                            
                            ForEach(hkService.stepData) { steps in
                                BarMark(
                                    x: .value("Date", steps.date, unit: .day),
                                    y: .value("Steps", steps.value)
                                )
                                .foregroundStyle(.pink.gradient)
                            }
                        }
                        .frame(height: 150)
                        .chartXAxis {
                            AxisMarks {
                                AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                            }
                        }
                        .chartYAxis {
                            AxisMarks { value in
                                AxisGridLine()
                                    .foregroundStyle(.gray.opacity(0.3))
                                
                                AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)) )
                            }
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(Color(.secondarySystemBackground))
                    }
                    
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
