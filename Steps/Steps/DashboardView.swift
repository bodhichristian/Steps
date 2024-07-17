//
//  ContentView.swift
//  Steps
//
//  Created by christian on 7/14/24.
//

import SwiftUI

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
    @State private var showingPrimer = false
    @State private var selectedState: HealthMetricContext = .steps
    
    var stepsSelected: Bool {
        selectedState == .steps
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
                                    
                                    Text("Avg: 10k Steps")
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                            .padding(.bottom, 12)
                        }
                        .foregroundStyle(.secondary)
                        
                        // Card Body
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 150)
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
            .onAppear {
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
