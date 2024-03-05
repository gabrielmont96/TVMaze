//
//  TabBarCoordinator.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 04/03/24.
//

import UIKit

class TabBarCoordinator: Coordinator {
    var childCoordinator: Coordinator?
    var viewController: UIViewController
    var navigationController: UINavigationController?
    
    let remoteShowListCoordinator = ShowsListCoordinator(provider: .remote)
    let favoritesShowListCoordinator = ShowsListCoordinator(provider: .favorites)
    
    init() {
        let tabBarController = UITabBarController()
        self.viewController = tabBarController
        self.start(controller: tabBarController)
    }
    
    func start(controller: UITabBarController) {
        controller.viewControllers = controllers()
        controller.tabBar.backgroundColor = .tabBarBackground
    }
}

extension TabBarCoordinator {
    func controllers() -> [UINavigationController] {
        let showListController = UINavigationController(rootViewController: remoteShowListCoordinator.viewController)
        remoteShowListCoordinator.navigationController = showListController
        showListController.tabBarItem.image = UIImage(systemName: "house.fill")
        showListController.tabBarItem.title = "Home"
        
        let favoritesShowListController = UINavigationController(rootViewController: favoritesShowListCoordinator.viewController)
        favoritesShowListCoordinator.navigationController = favoritesShowListController
        favoritesShowListController.tabBarItem.image = UIImage(systemName: "heart.fill")
        favoritesShowListController.tabBarItem.title = "Favorites"
        
        return [
            showListController,
            favoritesShowListController
        ]
    }
}
