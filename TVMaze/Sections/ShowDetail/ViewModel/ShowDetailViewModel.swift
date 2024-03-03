//
//  ShowDetailViewModel.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 02/03/24.
//

import Foundation

class ShowDetailViewModel {
    enum Sections {
        case details
        case seasons([ShowSeasonsModel])
        
        var title: String? {
            switch self {
            case .details:
                return nil
            case .seasons:
                return "Seasons"
            }
        }
        
        var numberOfRows: Int {
            switch self {
            case .details:
                return 1
            case .seasons(let seasons):
                return seasons.count
            }
        }
    }
    
    var sections: [Sections] = [.details]
    @Published var didFinishFetch: Bool?
    @Published var selectedEpisode: Int?
    
    @Published var viewDidDisappear: Bool?
    
    let show: ShowModel
    
    private let service: NetworkService<ShowsAPI>
    
    init(show: ShowModel, service: NetworkService<ShowsAPI> = NetworkService<ShowsAPI>()) {
        self.show = show
        self.service = service
    }
    
    func fetchSeasons() {
        Task { @MainActor in
            switch await service.request(target: .seasons(id: show.id), expecting: [ShowSeasonsModel].self) {
            case .success(let seasons):
                sections.append(.seasons(seasons))
                didFinishFetch = true
            case .failure(let error):
                print(error)
            }
        }
    }
}
