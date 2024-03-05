//
//  ShowsAPI.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation

enum ShowsAPI {
    case fetch(page: Int)
    case seasons(id: Int)
    case episodes(id: Int)
    case search(text: String)
}

extension ShowsAPI: NetworkAPI {
    var path: String {
        switch self {
        case .fetch(let page):
            return "/shows?page=\(page)"
        case .seasons(let id):
            return "/shows/\(id)/seasons"
        case .episodes(let id):
            return "/seasons/\(id)/episodes"
        case .search(let text):
            return "/search/shows?q=\(text.replacingOccurrences(of: " ", with: "%20"))"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}
