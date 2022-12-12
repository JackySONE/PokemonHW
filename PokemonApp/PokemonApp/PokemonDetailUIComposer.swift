//
//  PokemonDetailUIComposer.swift
//  PokemonApp
//
//  Created by 賴彥宇 on 2022/12/12.
//

import UIKit
import Pokemon
import PokemonIOS

public final class PokemonDetailUIComposer {
    private init() {}
    
    public static func pokemonDetailComposedWith(url: URL, pokemonDetailLoader: PokemonDetailLoader) -> PokemonDetailViewController {
        let presentationAdpter = PokemonDetailLoaderPresentationAdaptor<WeakRefVirtualProxy<PokemonDetailViewController>, UIImage>(
            url: url,
            pokemonDetailLoader: MainQueueDispatchDecorator(decoratee: pokemonDetailLoader))
        
        let viewController = makePokemonDetailViewController(delegate: presentationAdpter,
                                                             title: PokemonListPresenter.title)
        
        presentationAdpter.presenter = PokemonDetailViewPresenter(view: WeakRefVirtualProxy(viewController), imageTransformer: UIImage.init)
        
        return viewController
    }
    
    private static func makePokemonDetailViewController(delegate: PokemonDetailViewControllerDelegate, title: String) -> PokemonDetailViewController {
        let bundle = Bundle(for: PokemonDetailViewController.self)
        let storyboard = UIStoryboard(name: "PokemonDetail", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! PokemonDetailViewController
        controller.delegate = delegate
        return controller
    }
}

final class PokemonDetailLoaderPresentationAdaptor<View: PokemonDetailView, Image>: PokemonDetailViewControllerDelegate where View.Image == Image {
    private let url: URL
    private let pokemonDetailLoader: PokemonDetailLoader
    var presenter: PokemonDetailViewPresenter<View, Image>?
    
    init(url: URL, pokemonDetailLoader: PokemonDetailLoader) {
        self.url = url
        self.pokemonDetailLoader = pokemonDetailLoader
    }
    
    func didRequestPokemonDetail() {
        presenter?.didStartLoading()
        
        pokemonDetailLoader.load(url: url) { [weak self] result in
            switch result {
            case let .success(detail):
                self?.presenter?.didStarLoadingImageData(for: detail)
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
}
