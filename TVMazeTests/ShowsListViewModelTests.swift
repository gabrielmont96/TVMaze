//
//  ShowsListViewModelTests.swift
//  TVMazeTests
//
//  Created by Gabriel Monteiro Camargo da Silva on 04/03/24.
//

import XCTest
import Combine
@testable import TVMaze

class ShowsListViewModelTests: XCTestCase {
    var repository: ShowFavoritesRepositoryMock!
    var viewModel: ShowsListViewModel<ShowFavoritesRepositoryMock>!
    var executor: ExecutorMock!
    var cancellableBag: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellableBag = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        executor = nil
        repository = nil
        cancellableBag.removeAll()
        cancellableBag = nil
    }
    
    func testResetAndFetchShows() async {
        let expectation = XCTestExpectation(description: "waiting for response")
        setViewModel(provider: .remote)
        
        let task = Task {
            viewModel.$showFeedback
                .sink { [weak self] showLoading in
                    guard let self, showLoading != nil else { return }
                    XCTAssertEqual(self.viewModel.nextPage, 0)
                    XCTAssertEqual(self.viewModel.nextTargetIndex, 0)
                    expectation.fulfill()
                }
        }
        
        viewModel.resetAndFetchShows()
        await defaultWait(for: expectation)
        task.cancel()
    }
    
    func testLoadRemote() async {
        let expectation = XCTestExpectation(description: "waiting for response")
        setViewModel(provider: .remote)
        executor.mockedData = JSONDataGenerator().data(for: "show_model")
        
        XCTAssertEqual(viewModel.nextTargetIndex, 0)
        XCTAssertEqual(viewModel.shows.count, 0)
        XCTAssertEqual(viewModel.nextPage, 0)
        let task = Task {
            viewModel.$showFeedback
                .sink { [weak self] _ in
                    guard let self, !self.viewModel.shows.isEmpty else { return }
                    XCTAssertEqual(self.viewModel.shows.count, 100)
                    XCTAssertEqual(self.viewModel.nextPage, 1)
                    XCTAssertEqual(self.viewModel.nextTargetIndex, 70)
                    expectation.fulfill()
                }
                .store(in: &cancellableBag)
        }
        
        viewModel.loadFromRemote()
        await defaultWait(for: expectation)
        task.cancel()
    }
    
    func testLoadFavorites() async {
        let expectation = XCTestExpectation(description: "waiting for response")
        setViewModel(provider: .favorites)
        if let shows = try? JSONDecoder().decode([ShowModel].self, from: JSONDataGenerator().data(for: "show_model")) {
            repository.mockedShows = shows
        }
        
        let nextPage = viewModel.nextPage
        let nextTargetIndex = viewModel.nextTargetIndex
        let task = Task {
            viewModel.$showFeedback
                .sink { [weak self] _ in
                    guard let self, !self.viewModel.shows.isEmpty else { return }
                    XCTAssertTrue(self.repository.isCalledGetMethod)
                    XCTAssertEqual(self.viewModel.shows.count, 100)
                    XCTAssertEqual(self.viewModel.nextPage, nextPage)
                    XCTAssertEqual(self.viewModel.nextTargetIndex, nextTargetIndex)
                    expectation.fulfill()
                }
                .store(in: &cancellableBag)
        }
        
        viewModel.loadFromRepository()
        await defaultWait(for: expectation)
        task.cancel()
    }
    
    func testSearchForShowsFromRemote() async {
        let expectation = XCTestExpectation(description: "waiting for response")
        setViewModel(provider: .remote)
        executor.mockedData = JSONDataGenerator().data(for: "show_model_search")
        
        let nextPage = viewModel.nextPage
        let nextTargetIndex = viewModel.nextTargetIndex
        let task = Task {
            viewModel.$showFeedback
                .sink { [weak self] _ in
                    guard let self, !self.viewModel.shows.isEmpty else { return }
                    XCTAssertEqual(self.viewModel.shows.count, 2)
                    XCTAssertEqual(self.viewModel.nextPage, nextPage)
                    XCTAssertEqual(self.viewModel.nextTargetIndex, nextTargetIndex)
                    expectation.fulfill()
                }
                .store(in: &cancellableBag)
        }
        
        viewModel.searchForShows(using: "test")
        await defaultWait(for: expectation)
        task.cancel()
    }
    
    func testSearchForShowsFromRemoteWithEmptyString() async {
        let expectation = XCTestExpectation(description: "waiting for response")
        setViewModel(provider: .remote)
        executor.mockedData = JSONDataGenerator().data(for: "show_model")
        
        let task = Task {
            viewModel.$showFeedback
                .sink { [weak self] _ in
                    guard let self, !self.viewModel.shows.isEmpty else { return }
                    XCTAssertEqual(self.viewModel.shows.count, 100)
                    XCTAssertEqual(self.viewModel.nextPage, 1)
                    XCTAssertEqual(self.viewModel.nextTargetIndex, 70)
                    expectation.fulfill()
                }
                .store(in: &cancellableBag)
        }
        
        viewModel.searchForShows(using: "")
        await defaultWait(for: expectation)
        task.cancel()
    }
    
    func testSearchForShowsFromRepository() async {
        let expectation = XCTestExpectation(description: "waiting for response")
        setViewModel(provider: .favorites)
        if let shows = try? JSONDecoder().decode([ShowModel].self, from: JSONDataGenerator().data(for: "show_model")) {
            repository.mockedShows = shows
        }
        
        let nextPage = viewModel.nextPage
        let nextTargetIndex = viewModel.nextTargetIndex
        let task = Task {
            viewModel.$shows
                .sink { [weak self] shows in
                    guard let self, !shows.isEmpty else { return }
                    XCTAssertEqual(shows.count, 1)
                    XCTAssertEqual(self.viewModel.nextPage, nextPage)
                    XCTAssertEqual(self.viewModel.nextTargetIndex, nextTargetIndex)
                    expectation.fulfill()
                }
                .store(in: &cancellableBag)
        }
        
        viewModel.searchForShows(using: "GiRl")
        await defaultWait(for: expectation)
        task.cancel()
    }
}

extension ShowsListViewModelTests {
    func setViewModel(provider: ShowsListProvider) {
        executor = ExecutorMock()
        let service = NetworkService<ShowsAPI>()
        service.executor = executor
        repository = ShowFavoritesRepositoryMock()
        viewModel = ShowsListViewModel(provider: provider, service: service, favoritesRepository: repository)
    }
}
