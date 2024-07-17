//
//  HKPermissionPrimerView.swift
//  Steps
//
//  Created by christian on 7/15/24.
//

import SwiftUI
import HealthKitUI

struct HKPermissionPrimerView: View {
    @Environment(HealthKitService.self) var hkService
    @Environment(\.dismiss) var dismiss
    
    @Binding var permissionPrimed: Bool
    @State private var requestingPermission: Bool = false
    
    let permissionPrimer: String = """
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
                requestingPermission = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
            .frame(maxWidth: .infinity)
            .padding(.top, 160)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .interactiveDismissDisabled()
        .onAppear { permissionPrimed  = true }
        .healthDataAccessRequest(
            store: hkService.store,
            shareTypes: hkService.types,
            readTypes: hkService.types,
            trigger: requestingPermission) { result in
                switch result {
                case .success/*(let success)*/:
                    dismiss()
                case .failure/*(let failure)*/:
                    // handle error
                    
                    dismiss()
                }
            }
    }
}

#Preview {
    HKPermissionPrimerView(permissionPrimed: .constant(false))
        .environment(HealthKitService())
}
