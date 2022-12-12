//
//  PokemonDetailUIIntergrationTests.swift
//  PokemonAppTests
//
//  Created by 賴彥宇 on 2022/12/12.
//

import XCTest
import Pokemon
import PokemonIOS
import PokemonApp

final class PokemonDetailUIIntergrationTests: XCTestCase {
    
    func test_load_actions_request_details_from_loader() {
        let url = anyURL()
        let (sut, loader) = makeSUT(url: url)
        XCTAssertTrue(loader.messages.isEmpty)
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.messages, [.load(url)])
    }
    
    func test_on_load_success_renders_details() {
        let (sut, loader) = makeSUT(url: anyURL())
        let pokemonDetail = makeDetail()
        
        sut.loadViewIfNeeded()
        loader.loadCompletes(with: .success(pokemonDetail))
        
        assertThat(sut, hasViewConfiguredFor: pokemonDetail)
    }
}

private extension PokemonDetailUIIntergrationTests {
    func makeSUT(url: URL, file: StaticString = #file, line: UInt = #line) -> (PokemonDetailViewController, LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PokemonDetailUIComposer.pokemonDetailComposedWith(url: url,
                                                                    pokemonDetailLoader: loader)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    class LoaderSpy: PokemonDetailLoader {
        
        enum Message: Equatable {
            case load(URL)
        }
        
        private(set) var messages: [Message] = []
        
        typealias Result = PokemonDetailLoader.Result
        
        private var loadCompletions: [(Result) -> Void] = []
        func load(url: URL, completion: @escaping (Result) -> Void) {
            messages.append(.load(url))
            loadCompletions.append(completion)
        }
        
        func loadCompletes(with result: Result, at index: Int = 0) {
            loadCompletions[index](result)
        }
    }
    
    private func makeDetail() -> PokemonDetail {
        
        let properties = [PokemonDetail.Properties(name: "type1"),
                          PokemonDetail.Properties(name: "type2")]
        
        let detailModel = PokemonDetail(
            id: 123,
            imageURL: anyURL(),
            height: 30,
            weight: 34,
            properties: properties)
        
        return detailModel
    }
    
    func assertThat(_ sut: PokemonDetailViewController, hasViewConfiguredFor item: PokemonDetail, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.idText, String(item.id), file: file, line: line)
        XCTAssertEqual(sut.heightText, String(item.height), file: file, line: line)
        XCTAssertEqual(sut.weightText, String(item.weight), file: file, line: line)
    }
}

extension PokemonDetailViewController {
    
    var idText: String? {
        return idLabel.text
    }
    
    var heightText: String? {
        return heightLabel.text
    }
    
    var weightText: String? {
        return weightLabel.text
    }
}

func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}
