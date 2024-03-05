//
//  ShowsAPITests.swift
//  TVMazeTests
//
//  Created by Gabriel Monteiro Camargo da Silva on 04/03/24.
//

import XCTest
@testable import TVMaze

class ShowsAPITests: XCTestCase {
    func testPaths() {
        for id in 1...10 {
            XCTAssertEqual(ShowsAPI.fetch(page: id).path, "/shows?page=\(id)")
            XCTAssertEqual(ShowsAPI.episodes(id: id).path, "/seasons/\(id)/episodes")
            XCTAssertEqual(ShowsAPI.search(text: "\(id)").path, "/search/shows?q=\(id)")
            XCTAssertEqual(ShowsAPI.seasons(id: id).path, "/shows/\(id)/seasons")
        }
    }
    
    func testMethod() {
        XCTAssertEqual(ShowsAPI.fetch(page: 0).method, .get)
        XCTAssertEqual(ShowsAPI.episodes(id: 0).method, .get)
        XCTAssertEqual(ShowsAPI.search(text: "0").method, .get)
        XCTAssertEqual(ShowsAPI.seasons(id: 0).method, .get)
    }
    
    func testBaseURL() {
        XCTAssertEqual(ShowsAPI.seasons(id: 0).baseURL, .apiBaseURL)
    }
}
