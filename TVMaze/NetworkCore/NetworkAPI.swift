//
//  NetworkAPI.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol NetworkAPI {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
}

extension NetworkAPI {
    var baseURL: String {
        return .apiBaseURL
    }
    
    var headers: [String: String] {
        return [:]
    }
}
