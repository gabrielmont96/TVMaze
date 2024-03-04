//
//  RepositoryProtocol.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 04/03/24.
//

import Foundation
import CoreData

class CoreDataContextProvider {
    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Repository - Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var context: NSManagedObjectContext = persistentContainer.viewContext
    
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Repository - Unresolved error \(error), \(error.userInfo)")
        }
    }
}
