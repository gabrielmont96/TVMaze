//
//  NetworkError.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation

enum NetworkError: Error, Equatable {
    case api(statusCode: Int, message: String?)
    case invalidURL
    case parse(Error)
    case network(URLError)
    case unknown(Error)
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
