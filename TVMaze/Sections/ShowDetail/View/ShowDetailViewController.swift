//
//  ShowDetailViewController.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 02/03/24.
//

import UIKit
import Combine

class ShowDetailViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ShowDetailTableViewCell.self, forCellReuseIdentifier: ShowDetailTableViewCell.identifier)
        tableView.register(ShowDetailSeasonTableViewCell.self, forCellReuseIdentifier: ShowDetailSeasonTableViewCell.identifier)
        return tableView
    }()
    
    lazy var seasionHeaderSeactionLabel = {
        let label = UILabel()
        label.text = "Seasons"
        label.backgroundColor = .background
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    lazy var feedbackView: FeedbackView = {
        let feedbackView = FeedbackView()
        feedbackView.configure(.loading)
        return feedbackView
    }()
    
    var viewModel: ShowDetailViewModel<ShowFavoritesRepository>
    var cancellableBag = Set<AnyCancellable>()
    
    init(viewModel: ShowDetailViewModel<ShowFavoritesRepository>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = ShowDetailViewModel(show: .init(id: 0,
                                                    name: "",
                                                    genres: [],
                                                    schedule: .init(time: "", days: []),
                                                    image: nil,
                                                    summary: nil))
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupRightBarButton(isFavorite: viewModel.isFavorite)
        setupBindings()
        viewModel.fetchSeasons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            viewModel.viewDidDisappear = true
            tabBarController?.tabBar.isHidden = false
        }
    }
    
    func setupRightBarButton(isFavorite: Bool) {
        let image = {
            if isFavorite {
                UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            } else {
                UIImage(systemName: "heart")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            }
        }()
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc
    func favoriteButtonTapped() {
        viewModel.setFavorite()
        setupRightBarButton(isFavorite: viewModel.isFavorite)
    }
    
    func setupLayout() {
        view.backgroundColor = .background
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(16)
            make.leading.equalTo(view.snp.leading).inset(16)
            make.trailing.equalTo(view.snp.trailing).inset(16)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        feedbackView.show(in: view)
    }
    
    func setupBindings() {
        viewModel.$didFinishFetch
            .sink { [weak self] didFinishFetch in
                guard didFinishFetch != nil else { return }
                self?.tableView.reloadData()
                self?.feedbackView.remove()
            }.store(in: &cancellableBag)
    }
}

extension ShowDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].numberOfRows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.sections[section] {
        case .details:
            return nil
        case .seasons:
            return seasionHeaderSeactionLabel
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sections[indexPath.section] {
        case .details:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ShowDetailTableViewCell.identifier,
                                                        for: indexPath) as?  ShowDetailTableViewCell {
                cell.setup(viewModel.show)
                return cell
            }
        case .seasons(let seasons):
            let season = seasons[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: ShowDetailSeasonTableViewCell.identifier,
                                                        for: indexPath) as?  ShowDetailSeasonTableViewCell {
                cell.configure(season)
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension ShowDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.sections[indexPath.section] {
        case .seasons(let seasons):
            viewModel.selectedEpisode = seasons[indexPath.row].id
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.sections[indexPath.section] {
        case .details:
            return UITableView.automaticDimension
        case .seasons:
            return 48
        }
    }
}
