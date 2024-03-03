//
//  SeasonEpisodesViewController.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 03/03/24.
//

import UIKit
import Combine

class SeasonEpisodesViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .defaultBackgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SeasonEpisodeTableViewCell.self, forCellReuseIdentifier: SeasonEpisodeTableViewCell.identifier)
        return tableView
    }()
    
    var viewModel: SeasonEpisodesViewModel
    var cancellableBag = Set<AnyCancellable>()
    
    init(viewModel: SeasonEpisodesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = SeasonEpisodesViewModel(showId: 0)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
        viewModel.fetchEpisodes()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            viewModel.viewDidDisappear = true
        }
    }
    
    func setupBindings() {
        viewModel.$didFinishFetch
            .sink { [weak self] didFinishFetch in
                guard didFinishFetch != nil else { return }
                self?.tableView.reloadData()
            }.store(in: &cancellableBag)
    }
    
    func setupLayout() {
        view.backgroundColor = .defaultBackgroundColor
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(16)
            make.leading.equalTo(view.snp.leading).inset(16)
            make.trailing.equalTo(view.snp.trailing).inset(16)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
}

extension SeasonEpisodesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SeasonEpisodeTableViewCell.identifier,
                                                    for: indexPath) as?  SeasonEpisodeTableViewCell {
            cell.setup(episode: viewModel.episodes[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension SeasonEpisodesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.episodes[indexPath.row].isExpanded.toggle()
        tableView.reloadData()
    }
}
