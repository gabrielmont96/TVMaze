//
//  ShowsListViewModel.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation

class ShowsListViewModel<Repository: RepositoryProtocol> where Repository.T == ShowModel {
    @Published private(set) var shows: [ShowModel] = []
    @Published private(set) var selectedShow: ShowModel?
    @Published private(set) var showFeedback: FeedbackType?
    
    private(set) var nextPage = 0
    private(set) var lastSearch = ""
    var nextTargetIndex = 0
    
    private let service: NetworkService<ShowsAPI>
    let provider: ShowsListProvider
    private let favoritesRepository: Repository
    private var isFetching: Bool = false
    
    init(provider: ShowsListProvider,
         service: NetworkService<ShowsAPI> = NetworkService<ShowsAPI>(),
         favoritesRepository: Repository = ShowFavoritesRepository.shared) {
        self.service = service
        self.provider = provider
        self.favoritesRepository = favoritesRepository
    }
    
    private func fetchShows() {
        switch provider {
        case .remote:
            loadFromRemote()
        case .favorites:
            loadFromRepository()
        }
    }
    
    func viewWillAppear() {
        switch provider {
        case .remote where shows.isEmpty && lastSearch.isEmpty:
            showFeedback = .loading
            fetchShows()
        case .favorites:
            fetchShows()
        default:
            break
        }
    }
    
    func loadFromRemote() {
        isFetching = true
        Task { @MainActor in
            switch await service.request(target: .fetch(page: nextPage), expecting: [ShowModel].self) {
            case .success(let shows):
                if nextPage == 0 && nextTargetIndex == 0 {
                    self.shows = shows
                } else {
                    self.shows.append(contentsOf: shows)
                }
                self.nextPage = nextPage + 1
                nextTargetIndex = self.shows.count - 30
            case .failure(let error):
                // handle error
                print(error)
            }
            isFetching = false
            showFeedback = nil
        }
    }
    
    func loadFromRepository() {
        shows = favoritesRepository.get()
        if shows.isEmpty {
            showFeedback = .text(text: "Empty")
        } else {
            showFeedback = nil
        }
    }
    
    func searchForShows(using text: String) {
        switch provider {
        case .remote:
            guard !text.isEmpty else {
                resetAndFetchShows()
                return
            }
            lastSearch = text
            showFeedback = .loading
            isFetching = true
            Task { @MainActor in
                switch await service.request(target: .search(text: text), expecting: [ShowSearchModel].self) {
                case .success(let shows):
                    self.shows = shows.map { $0.show }
                case .failure(let error):
                    // handle error
                    print(error)
                }
                isFetching = false
                showFeedback = nil
            }
        case .favorites:
            shows = favoritesRepository.get().filter { $0.name.lowercased().starts(with: text.lowercased()) }
        }
    }
    
    func resetAndFetchShows() {
        nextPage = 0
        nextTargetIndex = 0
        fetchShowsIfNecessary(row: 0)
    }
    
    func fetchShowsIfNecessary(row: Int) {
        guard provider == .remote else { return }
        guard !isFetching,
              row >= nextTargetIndex else {
            /// should not load because the user didn't see the last 5 cells of the grid
            return
        }
        if nextPage == 0 {
            showFeedback = .loading
        }
        fetchShows()
        return
    }
    
    func didSelectShow(_ show: ShowModel) {
        selectedShow = show
    }
}
