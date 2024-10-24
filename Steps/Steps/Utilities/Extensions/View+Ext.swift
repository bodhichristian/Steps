//
//  View-InfiniteFrame.swift
//  Steps
//
//  Created by christian on 10/14/24.
//

import SwiftUI

enum FrameType {
    case infinite
}

extension View {
    func frame(
        _ frameType: FrameType
    ) -> some View {
        return self
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
    }
    
    func frame(
        _ frameType: FrameType,
        alignment: Alignment
    ) -> some View {
        return self
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: alignment
            )
    }
}


