//
//  TVMazeTests.swift
//  TVMazeTests
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation
@testable import TVMaze

enum TestAPI {
    case test(invalidPath: Bool =  false)
}

extension TestAPI: NetworkAPI {
    var path: String {
        if case .test(let invalidPath) = self, invalidPath {
            return ""
        } else {
            return "test"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .test:
            return .get
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .test:
            return ["keyTest": "valueTest"]
        }
    }
    
    var baseURL: String {
        if case .test(let invalidPath) = self, invalidPath {
            return ""
        } else {
            return "https://test.com/"
        }
    }
}
