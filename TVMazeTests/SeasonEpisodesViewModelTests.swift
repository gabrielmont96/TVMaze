//
//  SeasonEpisodesViewModelTests.swift
//  TVMazeTests
//
//  Created by Gabriel Monteiro Camargo da Silva on 04/03/24.
//

import XCTest
import Combine
@testable import TVMaze

class SeasonEpisodesViewModelTests: XCTestCase {
    var viewModel: SeasonEpisodesViewModel!
    var executor: ExecutorMock!
    var cancellableBag: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellableBag = Set<AnyCancellable>()
        executor = ExecutorMock()
        let service = NetworkService<ShowsAPI>()
        service.executor = executor
        viewModel = SeasonEpisodesViewModel(showId: 1, service: service)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        executor = nil
        cancellableBag.removeAll()
        cancellableBag = nil
    }
    
    func testFetchEpisodes() async {
        let expectation = XCTestExpectation(description: "waiting for response")
        executor.mockedData = JSONDataGenerator().data(for: "show_season_episodes")
        
        let task = Task {
            viewModel.$didFinishFetch
                .sink { [weak self] didFinishFetch in
                    guard let self, didFinishFetch != nil else { return }
                    XCTAssertEqual(self.viewModel.episodes.count, 4)
                    expectation.fulfill()
                }
                .store(in: &cancellableBag)
        }
        
        viewModel.fetchEpisodes()
        await defaultWait(for: expectation)
        task.cancel()
    }
}
