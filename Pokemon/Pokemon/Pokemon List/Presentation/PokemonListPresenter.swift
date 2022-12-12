//
//  PokemonListPresenter.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/12.
//

import Foundation

public protocol PokemonListView {
    func display(_ viewModel: PokemonListViewModel)
}

public protocol PokemonLoadingView {
    func display(_ viewModel: PokemonLoadingViewModel)
}

public protocol PokemonListErrorView {
    func display(_ viewModel: PokemonListErrorViewModel)
}

public final class PokemonListPresenter {
    private let pokemonListView: PokemonListView
    private let loadingView: PokemonLoadingView
    private let errorView: PokemonListErrorView
    
    private var pokemonListLoadError: String {
        return "Error message displayed when we can't load the pokemon list from the server"
    }
    
    public init(pokemonListView: PokemonListView,
                loadingView: PokemonLoadingView,
                errorView: PokemonListErrorView) {
        self.pokemonListView = pokemonListView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public static var title: String {
        return "Pokemon List"
    }
    
    public func didStartLoadingPokemonList() {
        errorView.display(.noError)
        loadingView.display(PokemonLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingList(with list: [Pokemon]) {
        pokemonListView.display(PokemonListViewModel(list: list))
        loadingView.display(PokemonLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingPokemonList(with error: Error) {
        errorView.display(.error(message: pokemonListLoadError))
        loadingView.display(PokemonLoadingViewModel(isLoading: false))
    }
}
