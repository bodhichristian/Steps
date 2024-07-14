//
//  ContentView.swift
//  Steps
//
//  Created by christian on 7/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 20) {
                    
                    
                    // Steps Card
                    VStack(alignment: .leading) {
                        // Card Header
                        HStack {
                            VStack(alignment: .leading) {
                                Label("Steps", systemImage: "figure.walk")
                                    .font(.title3.bold())
                                    .foregroundStyle(.pink)
                                
                                Text("Avg: 10k Steps")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.bottom, 12)
                        
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
            .navigationTitle("Dashboard")
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
