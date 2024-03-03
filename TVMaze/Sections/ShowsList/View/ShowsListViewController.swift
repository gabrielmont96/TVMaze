//
//  ShowsListViewController.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import UIKit
import Combine

class ShowsListViewController: UIViewController {
    lazy var showsView: ShowsView = {
        let homeView = ShowsView()
        homeView.configure(contents: viewModel.$shows)
        return homeView
    }()
    
    var viewModel: ShowsListViewModel
    var cancellableBag = Set<AnyCancellable>()
    
    init(viewModel: ShowsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = ShowsListViewModel()
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        self.view = showsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.startFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension ShowsListViewController {
    func setupBindings() {
        setupCollectionViewBindinds()
    }
    
    func setupCollectionViewBindinds() {
        showsView.$selectedShow
            .sink { [weak self] show in
                guard let show else { return }
                self?.viewModel.didSelectShow(show)
            }.store(in: &cancellableBag)
        
        showsView.$currentRow
            .sink { [weak self] row in
                guard let row else { return }
                self?.viewModel.fetchMoviesIfNecessary(row: row)
            }.store(in: &cancellableBag)
        
        showsView.$searchText
            .sink { [weak self] searchText in
                guard let searchText else { return }
                self?.viewModel.searchForShows(using: searchText)
            }.store(in: &cancellableBag)
    }
}
