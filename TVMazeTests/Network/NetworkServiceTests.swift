//
//  TVMazeTests.swift
//  TVMazeTests
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation
import XCTest
@testable import TVMaze

class NetworkServiceTests: XCTestCase {
    var service: NetworkService<TestAPI>!
    var executor: ExecutorMock!
    
    override func setUp() {
        super.setUp()
        executor = ExecutorMock()
        service = NetworkService<TestAPI>()
        service.executor = executor
    }
    
    override func tearDown() {
        super.tearDown()
        executor = nil
        service = nil
    }
    
    func testInvalidURL() async {
        let expectation = XCTestExpectation(description: "waiting for result")
        
        let task = Task {
            let result = await service.request(target: .test(invalidPath: true), expecting: TestModel.self)
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
            case .success:
                XCTFail("This test should be error")
            }
            expectation.fulfill()
        }

        await defaultWait(for: expectation)
        task.cancel()
    }
    
    func testParseError() async {
        executor.mockedData = "parseError".data(using: .utf8)
        let expectation = XCTestExpectation(description: "waiting for result")
        
        let task = Task {
            let result = await service.request(target: .test(), expecting: TestModel.self)
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .parse(NSError(domain: "generic", code: 0, userInfo: nil)))
            case .success:
                XCTFail("This test should be error")
            }
            expectation.fulfill()
        }
        
        await defaultWait(for: expectation)
        task.cancel()
    }
    
    func testUnknownError() async {
        executor.mockedData = "{ \"name\": \"Gabriel\" }".data(using: .utf8)
        let unknownError = NSError(domain: "unknown.error", code: 0)
        executor.error = unknownError
        let expectation = XCTestExpectation(description: "waiting for result")
        
        let task = Task {
            let result = await service.request(target: .test(), expecting: TestModel.self)
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unknown(unknownError))
            case .success:
                XCTFail("This test should be error")
            }
            expectation.fulfill()
        }
        
        await defaultWait(for: expectation)
        task.cancel()
    }
    
    func testAPIError() async {
        executor.mockedStatusCode = 401
        let expectation = XCTestExpectation(description: "waiting for result")
        
        let task = Task {
            let result = await service.request(target: .test(), expecting: TestModel.self)
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .api(statusCode: 401, message: nil))
            case .success:
                XCTFail("This test should be error")
            }
            expectation.fulfill()
        }
    
        await defaultWait(for: expectation)
        task.cancel()
    }
    
    func testParseSuccess() async {
        executor.mockedData = "{ \"name\": \"Gabriel\" }".data(using: .utf8)
        let expectation = XCTestExpectation(description: "waiting for result")
        
        let task = Task {
            let result = await service.request(target: .test(), expecting: TestModel.self)
            switch result {
            case .failure:
                XCTFail("This test should be success")
            case .success(let model):
                XCTAssertEqual(model.name, "Gabriel")
            }
            expectation.fulfill()
        }

        await defaultWait(for: expectation)
        task.cancel()
    }
}

private struct TestModel: Codable {
    let name: String
}
