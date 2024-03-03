//
//  ShowDetailTableView.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 02/03/24.
//

import UIKit

class ShowDetailTableView: UITableView {
    @Published var selectedEpisode: ShowModel?
    let show: ShowModel
    
    init(_ show: ShowModel) {
        self.show = show
        super.init(frame: .zero, style: .plain)
        delegate = self
        dataSource = self
        backgroundColor = .defaultBackgroundColor
        showsVerticalScrollIndicator = false
        register()
    }

    required init?(coder: NSCoder) {
        nil
    }
    
    func register() {
        register(ShowDetailTableViewCell.self, forCellReuseIdentifier: ShowDetailTableViewCell.identifier)
    }
}

extension ShowDetailTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ShowDetailTableViewCell.identifier, 
                                                    for: indexPath) as?  ShowDetailTableViewCell {
            cell.setup(show)
            return cell
        }
        return UITableViewCell()
    }
}

extension ShowDetailTableView: UITableViewDelegate {
    
}
