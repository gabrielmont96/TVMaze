//
//  RepositoryProtocol.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 04/03/24.
//

import Foundation

protocol RepositoryProtocol {
    associatedtype T
    
    func get() -> [T]
    func save(_ object: T)
    func delete(_ object: T)
    func update(_ object: T)
    func isOnStorage(_ object: T) -> Bool
}

extension RepositoryProtocol {
    func update(_ object: T) {}
}
