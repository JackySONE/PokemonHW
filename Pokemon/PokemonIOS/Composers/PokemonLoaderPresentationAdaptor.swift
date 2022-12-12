//
//  PokemonLoaderPresentationAdaptor.swift
//  PokemonIOS
//
//  Created by 賴彥宇 on 2022/12/12.
//

import Pokemon

final class PokemonLoaderPresentationAdaptor: PokemonListViewControllerDelegate {
    private let pokemonLoader: PokemonLoader
    var presenter: PokemonListPresenter?
    
    init(pokemonLoader: PokemonLoader) {
        self.pokemonLoader = pokemonLoader
    }
    
    func didRequestPokemon() {
        presenter?.didStartLoadingPokemonList()
        
        pokemonLoader.load { [weak self] result in
            switch result {
            case let .success(pokemonList):
                self?.presenter?.didFinishLoadingList(with: pokemonList)
            case let .failure(error):
                self?.presenter?.didFinishLoadingPokemonList(with: error)
            }
        }
    }
}
