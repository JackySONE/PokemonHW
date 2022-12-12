//
//  PokemonListUIComposer.swift
//  PokemonIOS
//
//  Created by 賴彥宇 on 2022/12/12.
//

import UIKit
import Pokemon
import PokemonIOS

public final class PokemonListUIComposer {
    private init() {}
    
    public static func pokemonListComposedWith(pokemonLoader: PokemonLoader) -> PokemonListViewController {
        let presentationAdpter = PokemonLoaderPresentationAdaptor(pokemonLoader: MainQueueDispatchDecorator(decoratee: pokemonLoader))
        
        let pokemonListViewController = makePokemonListViewController(delegate: presentationAdpter,
                                                                      title: PokemonListPresenter.title)
        
        presentationAdpter.presenter = PokemonListPresenter(
            pokemonListView: PokemonListViewAdaptor(controller: pokemonListViewController),
            loadingView: WeakRefVirtualProxy(pokemonListViewController),
            errorView: WeakRefVirtualProxy(pokemonListViewController))
        
        return pokemonListViewController
    }
    
    private static func makePokemonListViewController(delegate: PokemonListViewControllerDelegate, title: String) -> PokemonListViewController {
        let bundle = Bundle(for: PokemonListViewController.self)
        let storyboard = UIStoryboard(name: "PokemonList", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! PokemonListViewController
        controller.delegate = delegate
        controller.title = title
        return controller
    }
}
