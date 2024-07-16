//
//  StepsApp.swift
//  Steps
//
//  Created by christian on 7/14/24.
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
