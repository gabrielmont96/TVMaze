//
//  NetworkRequestFactory.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation

class NetworkRequestFactory {
    private let target: NetworkAPI
    
    init(target: NetworkAPI) {
        self.target = target
    }
    
    func build() throws -> URLRequest {
        guard let url = URL(string: "\(target.baseURL)\(target.path)") else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = target.method.rawValue
        
        for header in target.headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return urlRequest
    }
}
