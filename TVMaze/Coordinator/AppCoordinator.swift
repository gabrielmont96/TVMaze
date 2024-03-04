//
//  AppCoordinator.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import UIKit

class AppCoordinator {
    let window: UIWindow
    var coordinator: Coordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let coordinator = TabBarCoordinator()
        self.coordinator = coordinator
        window.rootViewController = coordinator.viewController
    }
}
