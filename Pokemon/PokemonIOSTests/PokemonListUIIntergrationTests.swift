//
//  PokemonListUIIntergrationTests.swift
//  PokemonIOSTests
//
//  Created by 賴彥宇 on 2022/12/12.
//

import XCTest
import UIKit
import Pokemon
import PokemonIOS

final class PokemonListUIIntergrationTests: XCTestCase {
    
    func test_pokemonListView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, "Pokemon List")
    }
    
    func test_loadPokemonListActions_requestPokemonFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadPokemonCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadPokemonCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedPokemonReload()
        XCTAssertEqual(loader.loadPokemonCallCount, 2, "Expected another loading request once user initiates a reload")
        
        sut.simulateUserInitiatedPokemonReload()
        XCTAssertEqual(loader.loadPokemonCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadingListIndicator_isVisibleWhileLoadingList() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completePokemonLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
        
        sut.simulateUserInitiatedPokemonReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completePokemonLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    func test_loadListCompletion_rendersSuccessfullyLoadedList() {
        let pokemon1 = makePokemon(name: "a pokemon")
        let pokemon2 = makePokemon(name: "b pokemon")
        let pokemon3 = makePokemon(name: "c pokemon")
        let pokemon4 = makePokemon(name: "d pokemon")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completePokemonLoading(with: [pokemon1], at: 0)
        assertThat(sut, isRendering: [pokemon1])
        
        sut.simulateUserInitiatedPokemonReload()
        loader.completePokemonLoading(with: [pokemon1, pokemon2, pokemon3, pokemon4], at: 1)
        assertThat(sut, isRendering: [pokemon1, pokemon2, pokemon3, pokemon4])
    }
    
    func test_loadListCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let pokemon1 = makePokemon(name: "a pokemon")
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completePokemonLoading(with: [pokemon1], at: 0)
        assertThat(sut, isRendering: [pokemon1])

        sut.simulateUserInitiatedPokemonReload()
        loader.completePokemonLoadingWithError(at: 1)
        assertThat(sut, isRendering: [pokemon1])
    }
    
    func test_loadListCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completePokemonLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_errorView_rendersErrorMessageOnErrorUntilNextReload() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        loader.completePokemonLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, "Error message displayed when we can't load the pokemon list from the server")

        sut.simulateUserInitiatedPokemonReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    func test_errorView_hideErrorMessageOnTap() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.errorMessage, nil)

        loader.completePokemonLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, "Error message displayed when we can't load the pokemon list from the server")

        sut.simulateTapOnErrorMessage()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PokemonListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PokemonListUIComposer.pokemonListComposedWith(pokemonLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func makePokemon(name: String, url: URL = URL(string: "http://any-url.com")!) -> Pokemon {
        return Pokemon(name: name, url: url)
    }}

extension PokemonListUIIntergrationTests {
    
    class LoaderSpy: PokemonLoader {
        
        // MARK: - FeedLoader
        
        private var requests = [(PokemonLoader.Result) -> Void]()
        
        var loadPokemonCallCount: Int {
            return requests.count
        }
        
        func load(completion: @escaping (PokemonLoader.Result) -> Void) {
            requests.append(completion)
        }
        
        func completePokemonLoading(with list: [Pokemon] = [], at index: Int = 0) {
            requests[index](.success(list))
        }
        
        func completePokemonLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            requests[index](.failure(error))
        }
    }
    
}

extension PokemonListViewController {
    func simulateUserInitiatedPokemonReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func simulateTapOnErrorMessage() {
        errorView?.button.simulateTap()
    }
    
    var errorMessage: String? {
        return errorView?.message
    }

    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }

    func numberOfRenderedPokmonViews() -> Int {
        return tableView.numberOfRows(inSection: pokemonSection)
    }

    func pokemonView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: pokemonSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    private var pokemonSection: Int {
        return 0
    }
}




