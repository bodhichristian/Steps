//
//  BackgroundView.swift
//  Steps
//
//  Created by christian on 7/16/24.
//

import SwiftUI

struct BackgroundGradient: View {
    @Environment(\.colorScheme) var colorScheme
    
    var darkMode: Bool { colorScheme == .dark }
    
    var body: some View {
        Rectangle()
            .foregroundStyle(
                darkMode ? Color.black.gradient :  Color.white.gradient
            )
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundGradient()
}
