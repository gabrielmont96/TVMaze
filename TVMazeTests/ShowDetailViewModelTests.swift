//
//  ShowsListViewModelTests.swift
//  TVMazeTests
//
//  Created by Gabriel Monteiro Camargo da Silva on 04/03/24.
//

import XCTest
import Combine
@testable import TVMaze

class ShowDetailViewModelTests: XCTestCase {
    var repository: ShowFavoritesRepositoryMock!
    var viewModel: ShowDetailViewModel<ShowFavoritesRepositoryMock>!
    var executor: ExecutorMock!
    var cancellableBag: Set<AnyCancellable>!
    
    let showModel = ShowModel(id: 0,
                              name: "test",
                              genres: ["test"],
                              schedule: ShowSchedule(time: "test", days: ["test"]),
                              image: ShowImage(medium: "test"),
                              summary: "test")
    
    override func setUp() {
        super.setUp()
        cancellableBag = Set<AnyCancellable>()
        executor = ExecutorMock()
        let service = NetworkService<ShowsAPI>()
        service.executor = executor
        repository = ShowFavoritesRepositoryMock()
        viewModel = ShowDetailViewModel(show: showModel, service: service, favoritesRepository: repository)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        executor = nil
        repository = nil
        cancellableBag.removeAll()
        cancellableBag = nil
    }
    
    func testInitialSectionState() {
        XCTAssertEqual(viewModel.sections.count, 1)
        XCTAssertEqual(viewModel.sections[0].numberOfRows, 1)
        XCTAssertTrue(viewModel.sections[0] == .details)
        XCTAssertNil(viewModel.sections[0].title)
    }
    
    func testFetchSeasons() async {
        let expectation = XCTestExpectation(description: "waiting for response")
        executor.mockedData = JSONDataGenerator().data(for: "show_seasons")
        
        XCTAssertEqual(viewModel.sections.count, 1)
        XCTAssertEqual(viewModel.sections[0], .details)
        let task = Task {
            viewModel.$didFinishFetch
                .sink { [weak self] didFinishFetch in
                    guard let self, didFinishFetch != nil else { return }
                    if case .seasons(let seasons) = self.viewModel.sections[1] {
                        XCTAssertEqual(self.viewModel.sections.count, 2)
                        XCTAssertEqual(self.viewModel.sections[1].title, "Seasons")
                        XCTAssertEqual(self.viewModel.sections[1].numberOfRows, seasons.count)
                        expectation.fulfill()
                    }
                }
                .store(in: &cancellableBag)
        }
        
        viewModel.fetchSeasons()
        await defaultWait(for: expectation)
        task.cancel()
    }
    
    func testSetFavorite() {
        viewModel.isFavorite = false
        
        viewModel.setFavorite()
        XCTAssertTrue(viewModel.isFavorite)
        XCTAssertTrue(repository.isCalledSaveMethod)
        
        viewModel.setFavorite()
        XCTAssertFalse(viewModel.isFavorite)
        XCTAssertTrue(repository.isCalledDeleteMethod)
    }
}
