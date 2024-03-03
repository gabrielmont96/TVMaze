//
//  SeasonEpisodesCoordinator.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 02/03/24.
//

import UIKit

class SeasonEpisodesCoordinator: Coordinator {
    var childCoordinator: Coordinator?
    var viewController: UIViewController
    var navigationController: UINavigationController?
    
    @Published var didFinish: Bool?
    
    init(showId: Int) {
        let viewModel = SeasonEpisodesViewModel(showId: showId)
        viewController = SeasonEpisodesViewController(viewModel: viewModel)
        viewModel.$viewDidDisappear.assign(to: &$didFinish)
    }
}
