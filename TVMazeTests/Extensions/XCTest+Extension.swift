//
//  XCTest+Extension.swift
//  TVMazeTests
//
//  Created by Gabriel Monteiro Camargo da Silva on 04/03/24.
//

import XCTest

extension XCTestCase {
    func defaultWait(for fulfillments: XCTestExpectation...) async {
        await fulfillment(of: fulfillments, timeout: 1.0)
    }
}
