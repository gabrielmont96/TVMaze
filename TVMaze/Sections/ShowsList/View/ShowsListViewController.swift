//
//  ShowsListViewController.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import UIKit
import Combine

class ShowsListViewController: UIViewController {
    lazy var collectionView: ShowsCollectionView = {
        var collectionView = ShowsCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var feedbackView: FeedbackView = {
        let feedbackView = FeedbackView()
        feedbackView.configure(.loading)
        return feedbackView
    }()
    
    var viewModel: ShowsListViewModel<ShowFavoritesRepository>
    var cancellableBag = Set<AnyCancellable>()
    
    init(viewModel: ShowsListViewModel<ShowFavoritesRepository>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = ShowsListViewModel(provider: .remote)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupLayout() {
        view.backgroundColor = .background
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.leading.equalTo(view.snp.leading).inset(16)
            make.trailing.equalTo(view.snp.trailing).inset(16)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        if viewModel.provider == .remote {
            feedbackView.show(in: view)
        }
    }
}

extension ShowsListViewController {
    func setupBindings() {
        setupCollectionViewBindinds()
    }
    
    func setupCollectionViewBindinds() {
        collectionView.setupContentsBinding(shows: viewModel.$shows)
        
        collectionView.$selectedShow
            .sink { [weak self] show in
                guard let show else { return }
                self?.viewModel.didSelectShow(show)
            }.store(in: &cancellableBag)
        
        collectionView.$currentRow
            .sink { [weak self] row in
                guard let row else { return }
                self?.viewModel.fetchShowsIfNecessary(row: row)
            }.store(in: &cancellableBag)
        
        collectionView.$searchText
            .sink { [weak self] searchText in
                guard let searchText else { return }
                self?.viewModel.searchForShows(using: searchText)
            }.store(in: &cancellableBag)
        
        viewModel.$showFeedback
            .sink { [weak self] showFeedback in
                guard let self, let showFeedback else {
                    self?.feedbackView.remove(withDelay: self?.viewModel.provider == .remote ? 0.3 : 0)
                    return
                }
                self.feedbackView.configure(showFeedback)
                self.feedbackView.show(in: self.view)
            }
            .store(in: &cancellableBag)
    }
}
