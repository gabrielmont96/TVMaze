//
//  URLResponse+Extensions.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation

extension URLResponse {
    func isSuccess() -> Bool {
        if let httpResponse = self as? HTTPURLResponse {
            return 200...299 ~= httpResponse.statusCode
        } else {
            return false
        }
    }
}
