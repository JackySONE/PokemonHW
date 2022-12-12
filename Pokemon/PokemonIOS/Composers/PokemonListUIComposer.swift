//
//  PokemonListUIComposer.swift
//  PokemonIOS
//
//  Created by 賴彥宇 on 2022/12/12.
//

import UIKit
import Pokemon

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

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: PokemonLoader where T == PokemonLoader {
    func load(completion: @escaping (PokemonLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
