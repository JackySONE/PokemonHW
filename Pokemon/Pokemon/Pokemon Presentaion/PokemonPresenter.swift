//
//  PokemonPresenter.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/12.
//

import Foundation

public protocol PokemonView {
    func display(_ model: PokemonViewModel)
}

public final class PokemonPresenter {
    private let pokemonView: PokemonView
    
    public init(pokemonView: PokemonView) {
        self.pokemonView = pokemonView
    }
    
    public func display(with model: Pokemon) {
        pokemonView.display(PokemonViewModel(name: model.name))
    }
}
