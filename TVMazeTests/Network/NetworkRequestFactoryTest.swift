//
//  TVMazeTests.swift
//  TVMazeTests
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation
import XCTest
@testable import TVMaze

class NetworkRequestFactoryTest: XCTestCase {
    let target = ShowsAPI.fetch(page: 0)
    lazy var requestFactory = NetworkRequestFactory(target: target)
    
    func testURLWithSuccess() {
        do {
            let request = try requestFactory.build()
            XCTAssertEqual(request.url, URL(string: "\(target.baseURL)\(target.path)"))
        } catch {
            XCTFail("this test should not fall into catch block")
        }
    }
    
    func testURLWithFailure() {
        do {
            _ = try NetworkRequestFactory(target: TestAPI.test(invalidPath: true)).build()
            XCTFail("this test should fall into catch block")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("this test should not fall into catch block")
        }
    }
    
    func testMethod() {
        do {
            let request = try requestFactory.build()
            XCTAssertEqual(request.httpMethod, target.method.rawValue)
        } catch {
            XCTFail("this test should not fall into catch block")
        }
    }
}
