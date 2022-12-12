//
//  PokemonListViewController+Assertions.swift
//  PokemonIOSTests
//
//  Created by 賴彥宇 on 2022/12/12.
//

import XCTest
import Pokemon
import PokemonIOS

extension PokemonListUIIntergrationTests {

    func assertThat(_ sut: PokemonListViewController, isRendering list: [Pokemon], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedPokmonViews() == list.count else {
            return XCTFail("Expected \(list.count) pokemon, got \(sut.numberOfRenderedPokmonViews()) instead.", file: file, line: line)
        }
        
        list.enumerated().forEach { index, pokemon in
            assertThat(sut, hasViewConfiguredFor: pokemon, at: index, file: file, line: line)
        }
    }
    
    func assertThat(_ sut: PokemonListViewController, hasViewConfiguredFor pokemon: Pokemon, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.pokemonView(at: index)
        
        guard let cell = view as? PokemonCell else {
            return XCTFail("Expected \(PokemonCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(cell.nameLabel.text, pokemon.name, "Expected description text to be \(String(describing: pokemon.name)) for pokemon view at index (\(index)", file: file, line: line)
    }
    
}
