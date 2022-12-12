//
//  PokemonListPresenterTests.swift
//  PokemonTests
//
//  Created by 賴彥宇 on 2022/12/12.
//

import XCTest
import Pokemon

final class PokemonListPresenterTests: XCTestCase {

    func test_title_isLocalized() {
        XCTAssertEqual(PokemonListPresenter.title, "Pokemon List")
    }

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingPokemon_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()

        sut.didStartLoadingPokemonList()

        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingPokemon_displaysFeedAndStopsLoading() {
        let (sut, view) = makeSUT()
        
        let list = pokemonList()
        
        sut.didFinishLoadingList(with: list)
        
        XCTAssertEqual(view.messages, [
            .display(list: list),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingPokemonWithError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoadingPokemonList(with: anyNSError())
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: "Error message displayed when we can't load the pokemon list from the server"),
            .display(isLoading: false)
        ])
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PokemonListPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = PokemonListPresenter(pokemonListView: view, loadingView: view, errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    private class ViewSpy: PokemonListView, PokemonLoadingView, PokemonListErrorView {
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(list: [Pokemon])
        }
        
        private(set) var messages = Set<Message>()
                
        func display(_ viewModel: PokemonListViewModel) {
            messages.insert(.display(list: viewModel.list))
        }
        
        func display(_ viewModel: PokemonLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: PokemonListErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
    }
    
    private func pokemonList() -> [Pokemon] {
        return [Pokemon(name: "PokemonA", url: anyURL()),
                Pokemon(name: "PokemonB", url: anyURL())]
    }

}


