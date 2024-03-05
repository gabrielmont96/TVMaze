//
//  TVMazeTests.swift
//  TVMazeTests
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation

class JSONDataGenerator {
    func data(for name: String) -> Data {
        if let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "json"),
           let data = try? Data(contentsOf: url, options: .mappedIfSafe) {
            return data
        }
        return Data()
    }
}
