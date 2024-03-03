//
//  CancelBag.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Combine

typealias CancelBag = Set<AnyCancellable>

extension CancelBag {
    mutating func cancelAll() {
        forEach { $0.cancel() }
        removeAll()
    }
}
