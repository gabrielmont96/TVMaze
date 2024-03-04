//
//  ShowFavoritesRepository.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 04/03/24.
//

import Foundation

class ShowFavoritesRepository: RepositoryProtocol {
    static let shared = ShowFavoritesRepository(modelName: "ShowFavorites")
    
    private let coreDataBase: CoreDataContextProvider
    
    init(modelName: String = "ShowFavorites") {
        self.coreDataBase = CoreDataContextProvider(modelName: modelName)
    }
    
    func get() -> [ShowModel] {
        do {
            let request = ShowFavoritesItem.fetchRequest()
            let sort = NSSortDescriptor(key: #keyPath(ShowFavoritesItem.name), ascending: true)
            request.sortDescriptors = [sort]
            let items = try coreDataBase.context.fetch(request)
            return items.map { $0.toShowModel() }
        } catch {
            print(error)
            return []
        }
    }
    
    func save(_ object: ShowModel) {
        if !isOnStorage(object) {
            let item = ShowFavoritesItem(context: coreDataBase.context)
            item.id = Int32(object.id)
            item.image = object.image?.medium
            item.name = object.name
            item.genres = object.genres
            item.scheduleDays = object.schedule.days
            item.scheduleTime = object.schedule.time
            coreDataBase.saveContext()
        }
    }
    
    func delete(_ object: ShowModel) {
        let request = ShowFavoritesItem.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", object.name)
        request.predicate = predicate
        do {
            for object in try coreDataBase.context.fetch(request) {
                coreDataBase.context.delete(object)
            }
        } catch {
            print(error)
        }
        
        coreDataBase.saveContext()
    }
    
    func isOnStorage(_ object: ShowModel) -> Bool {
        let request = ShowFavoritesItem.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", object.name)
        request.predicate = predicate
        do {
            return try !coreDataBase.context.fetch(request).isEmpty
        } catch {
            return false
        }
    }
}
