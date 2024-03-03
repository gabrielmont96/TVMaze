//
//  ShowDetailCoordinator.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 02/03/24.
//

import UIKit
import Combine

class ShowDetailCoordinator: Coordinator {
    var childCoordinator: Coordinator?
    var viewController: UIViewController
    var navigationController: UINavigationController?
    
    @Published var didFinish: Bool?
    
    var viewModelCancellableBag = Set<AnyCancellable>()
    var childCoordinatorCancellableBag = Set<AnyCancellable>()
    
    init(show: ShowModel) {
        let viewModel = ShowDetailViewModel(show: show)
        viewController = ShowDetailViewController(viewModel: viewModel)
        setupObservable(for: viewModel.$selectedEpisode)
        viewModel.$viewDidDisappear.assign(to: &$didFinish)
    }
    
    func setupObservable(for selectedEpisode: Published<Int?>.Publisher) {
        selectedEpisode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showId in
                guard let showId else { return }
                self?.openShowSeasonEpisodes(showId: showId)
            }.store(in: &viewModelCancellableBag)
    }
}

extension ShowDetailCoordinator {
    func openShowSeasonEpisodes(showId: Int) {
        guard let navigationController else { return }
        let coordinator = SeasonEpisodesCoordinator(showId: showId)
        route(to: coordinator, withPresenter: .push(navigationController), animated: true)
        coordinator.$didFinish.sink { [weak self] didFinish in
            guard didFinish != nil else { return }
            self?.didFinishSeasonEpisodes()
        }.store(in: &childCoordinatorCancellableBag)
    }
    
    func didFinishSeasonEpisodes() {
        childCoordinator = nil
        childCoordinatorCancellableBag.cancelAll()
    }
}
