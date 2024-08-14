//
//  StepsApp.swift
//  Steps
//
//  Created by christian on 8/8/24.
//

import SwiftUI

@main
struct StepsApp: App {
    let hkService = HealthKitService()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkService)
        }
    }
}
