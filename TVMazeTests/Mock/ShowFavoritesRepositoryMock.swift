//
//  ShowFavoritesRepositoryStub.swift
//  TVMazeTests
//
//  Created by Gabriel Monteiro Camargo da Silva on 04/03/24.
//

@testable import TVMaze

class ShowFavoritesRepositoryMock: RepositoryProtocol {
    var mockedShows: [ShowModel] = []
    
    var isCalledGetMethod = false
    var isCalledSaveMethod = false
    var isCalledDeleteMethod = false
    
    func get() -> [ShowModel] {
        isCalledGetMethod = true
        return mockedShows
    }
    
    func save(_ object: ShowModel) {
        mockedShows.append(object)
        isCalledSaveMethod = true
    }
    
    func delete(_ object: ShowModel) {
        isCalledDeleteMethod = true
        return mockedShows.removeAll { $0.id == object.id }
    }
    
    func isOnStorage(_ object: ShowModel) -> Bool {
        return mockedShows.contains { $0.id == object.id }
    }
}
