//
//  SeasonSpisodesViewModel.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 03/03/24.
//

import Foundation

class SeasonEpisodesViewModel {
    var episodes: [SeasonEpisodesModel] = []
    @Published var didFinishFetch: Bool?
    @Published var viewDidDisappear: Bool?
    
    private let service: NetworkService<ShowsAPI>
    private let showId: Int
    
    init(showId: Int, service: NetworkService<ShowsAPI> = NetworkService<ShowsAPI>()) {
        self.service = service
        self.showId = showId
    }
    
    func fetchEpisodes() {
        Task { @MainActor in
            switch await service.request(target: .episodes(id: showId), expecting: [SeasonEpisodesModel].self) {
            case .success(let seasonEpisodes):
                episodes = seasonEpisodes
                didFinishFetch = true
            case .failure(let error):
                print(error)
            }
        }
    }
}
