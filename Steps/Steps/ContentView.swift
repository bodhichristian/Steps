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

struct ContentView: View {
    @State private var selectedState: HealthMetricContext = .steps
    
    var stepsSelected: Bool {
        selectedState == .steps
    }
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 20) {
                    
                    Picker("Selected Stat", selection: $selectedState) {
                        ForEach(HealthMetricContext.allCases) { metric in
                            Text(metric.title)
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
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                Text(metric.title)
            }
        }
        .tint(stepsSelected ? .pink : .indigo)
    }
}

#Preview {
    ContentView()
}
