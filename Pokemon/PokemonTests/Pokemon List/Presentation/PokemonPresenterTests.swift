//
//  PokemonPresenterTests.swift
//  PokemonTests
//
//  Created by 賴彥宇 on 2022/12/12.
//

import XCTest
import Pokemon

final class PokemonPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didFinishLoadingFeed_displaysFeedAndStopsLoading() {
        let (sut, view) = makeSUT()
        
        let pokemon = pokemon()
        
        sut.display(with: pokemon)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.name, pokemon.name)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PokemonPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = PokemonPresenter(pokemonView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    private class ViewSpy: PokemonView {
        private(set) var messages = [PokemonViewModel]()

        func display(_ model: PokemonViewModel) {
            messages.append(model)
        }
    }
    
    private func pokemon() -> Pokemon {
        return Pokemon(name: "PokemonA", url: anyURL())
    }

}
