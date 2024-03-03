//
//  ShowsListViewModel.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation

class ShowsListViewModel {
    @Published private(set) var shows: [ShowModel] = []
    @Published private(set) var selectedShow: ShowModel?
    
    private(set) var nextPage = 0
    var nextTargetIndex = 0
    var isFetching = false
    
    private let service: NetworkService<ShowsAPI>
    
    init(service: NetworkService<ShowsAPI> = NetworkService<ShowsAPI>()) {
        self.service = service
    }
    
    private func fetchShows(page: Int) {
        isFetching = true
        Task { @MainActor in
            switch await service.request(target: .fetch(page: page), expecting: [ShowModel].self) {
            case .success(let shows):
                if nextPage == 0 && nextTargetIndex == 0 {
                    self.shows = shows
                } else {
                    self.shows.append(contentsOf: shows)
                }
                self.nextPage = page + 1
                self.nextTargetIndex = self.shows.count - 30
                self.isFetching = false
            case .failure:
                self.isFetching = false
                // handle error
            }
        }
    }
    
    func searchForShows(using text: String) {
        guard !text.isEmpty else {
            resetAndFetchShows()
            return
        }
        isFetching = true
        Task { @MainActor in
            switch await service.request(target: .search(text: text), expecting: [ShowSearchModel].self) {
            case .success(let shows):
                self.shows = shows.map { $0.show }
                self.isFetching = false
            case .failure:
                self.isFetching = false
                // handle error
            }
        }
    }
    
    func resetAndFetchShows() {
        nextPage = 0
        nextTargetIndex = 0
        fetchMoviesIfNecessary(row: 0)
    }
    
    @discardableResult
    func fetchMoviesIfNecessary(row: Int) -> Bool {
        guard !isFetching,
              row >= nextTargetIndex else {
            /// should not load because the user didn't see the last 5 cells of the grid
            return false
        }
        fetchShows(page: nextPage)
        return true
    }
    
    func startFetch() {
        fetchShows(page: nextPage)
    }
    
    func didSelectShow(_ show: ShowModel) {
        selectedShow = show
    }
}
