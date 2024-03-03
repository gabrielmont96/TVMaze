//
//  ShowsListCoordinator.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import UIKit
import Combine

class ShowsListCoordinator: Coordinator {
    var childCoordinator: Coordinator?
    var viewController: UIViewController
    var navigationController: UINavigationController?
    
    var viewModelCancellableBag = Set<AnyCancellable>()
    var childCoordinatorCancellableBag = Set<AnyCancellable>()
    
    init() {
        let viewModel = ShowsListViewModel()
        viewController = ShowsListViewController(viewModel: viewModel)
        setupObservable(for: viewModel.$selectedShow)
    }
    
    func setupObservable(for selectedShow: Published<ShowModel?>.Publisher) {
        selectedShow
            .receive(on: DispatchQueue.main)
            .sink { [weak self] show in
                guard let show else { return }
                self?.openShowDetail(show: show)
            }.store(in: &viewModelCancellableBag)
    }
}

extension ShowsListCoordinator {
    func openShowDetail(show: ShowModel) {
        guard let navigationController else { return }
        let coordinator = ShowDetailCoordinator(show: show)
        route(to: coordinator, withPresenter: .push(navigationController), animated: true)
        coordinator.$didFinish.sink { [weak self] didFinish in
            guard didFinish != nil else { return }
            self?.didFinishShowDetail()
        }.store(in: &childCoordinatorCancellableBag)
    }
    
    func didFinishShowDetail() {
        childCoordinator = nil
        childCoordinatorCancellableBag.cancelAll()
    }
}
