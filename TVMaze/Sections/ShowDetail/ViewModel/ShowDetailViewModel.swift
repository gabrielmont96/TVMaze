//
//  ShowDetailViewModel.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 02/03/24.
//

import Foundation

class ShowDetailViewModel<Repository: RepositoryProtocol> where Repository.T == ShowModel {
    enum Sections: Equatable {
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
        
        static func == (lhs: ShowDetailViewModel<Repository>.Sections, rhs: ShowDetailViewModel<Repository>.Sections) -> Bool {
            return lhs.title == lhs.title && lhs.numberOfRows == lhs.numberOfRows
        }
    }
    
    var sections: [Sections] = [.details]
    @Published var didFinishFetch: Bool?
    @Published var selectedEpisode: Int?
    @Published var viewDidDisappear: Bool?
    
    let favoritesRepository: Repository
    var isFavorite: Bool = false
    
    let show: ShowModel
    
    private let service: NetworkService<ShowsAPI>
    
    init(show: ShowModel,
         service: NetworkService<ShowsAPI> = NetworkService<ShowsAPI>(),
         favoritesRepository: Repository = ShowFavoritesRepository.shared) {
        self.show = show
        self.service = service
        self.favoritesRepository = favoritesRepository
        self.isFavorite = favoritesRepository.isOnStorage(show)
    }
    
    func fetchSeasons() {
        Task { @MainActor in
            switch await service.request(target: .seasons(id: show.id), expecting: [ShowSeasonsModel].self) {
            case .success(let seasons):
                sections.append(.seasons(seasons))
                didFinishFetch = true
            case .failure(let error):
                // handle error
                print(error)
            }
        }
    }
    
    func setFavorite() {
        if !isFavorite {
            favoritesRepository.save(show)
        } else {
            favoritesRepository.delete(show)
        }
        isFavorite.toggle()
    }
}
