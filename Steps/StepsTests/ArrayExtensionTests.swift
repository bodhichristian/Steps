//
//  StepsTests.swift
//  StepsTests
//
//  Created by christian on 10/31/24.
//

import Testing
@testable import Steps

struct ArrayExtensionTests {

    @Test func arrayAverage() async throws {
        let array: [Double] = [2.0, 3.1, 0.45, 1.84]
        #expect(array.average == 1.8475)
    }

}
