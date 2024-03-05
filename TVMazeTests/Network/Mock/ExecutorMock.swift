//
//  TVMazeTests.swift
//  TVMazeTests
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation
@testable import TVMaze

class ExecutorMock: Executor {
    
    var configuration = URLSessionConfiguration.default
    
    var mockedData: Data?
    var mockedStatusCode = 200
    var error: Error?
    var mockedResponseHeaders: [String: String]? = [:]
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error {
            throw error
        }
        guard let url = request.url else { return  (Data(), URLResponse()) }
        let urlResponse = HTTPURLResponse(url: url,
                                          statusCode: mockedStatusCode,
                                          httpVersion: nil,
                                          headerFields: mockedResponseHeaders)
        return (mockedData ?? Data(), urlResponse ?? URLResponse())
    }
}
