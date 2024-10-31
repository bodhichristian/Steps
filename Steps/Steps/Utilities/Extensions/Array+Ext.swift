//
//  Array+Ext.swift
//  Steps
//
//  Created by christian on 10/24/24.
//

import Foundation

extension Array where Element == Double {
    // extend Array of type Double
    var average: Double {
        guard !self.isEmpty else { return 0 } // guard against an empty array
        let total = self.reduce(0, +) // get the sum of element values
        return total/Double(self.count) // divide by the number of elements
    }
}
