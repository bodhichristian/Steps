//
//  HKPermissionPrimerView.swift
//  Steps
//
//  Created by christian on 7/15/24.
//

import SwiftUI

struct HKPermissionPrimerView: View {
    
    var permissionPrimer: String = """
    This app provides interactive charts to explore your step and weight data.
    
    You may securely add new data to Apple Health directly from this app.
    """
    
    var body: some View {
        VStack(alignment: .leading) {
            Image("appleHealth")
                .resizable()
                .frame(width: 80, height: 80)
                .shadow(color: .gray.opacity(0.3), radius: 16)
                .padding(.bottom)
            
            Text("Apple Health Integration")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(permissionPrimer)
                .foregroundStyle(.secondary)
            
            Button("Connect to Apple Health") {
                // do something
                
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
            .frame(maxWidth: .infinity)
            .padding(.top, 160)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    HKPermissionPrimerView()
}
