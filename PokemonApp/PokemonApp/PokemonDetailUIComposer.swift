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
    
    public static func pokemonDetailComposedWith(url: URL,
                                                 pokemonDetailLoader: PokemonDetailLoader,
                                                 imageLoader: ImageDataLoader) -> PokemonDetailViewController {
        let presentationAdpter = PokemonDetailLoaderPresentationAdaptor<WeakRefVirtualProxy<PokemonDetailViewController>, UIImage>(
            url: url,
            pokemonDetailLoader: MainQueueDispatchDecorator(decoratee: pokemonDetailLoader),
            imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader))
        
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
    private let imageLoader: ImageDataLoader
    private var task: ImageDataLoaderTask?
    
    var presenter: PokemonDetailViewPresenter<View, Image>?
    
    init(url: URL, pokemonDetailLoader: PokemonDetailLoader, imageLoader: ImageDataLoader) {
        self.url = url
        self.pokemonDetailLoader = pokemonDetailLoader
        self.imageLoader = imageLoader
    }
    
    func didRequestPokemonDetail() {
        presenter?.didStartLoading()
        
        pokemonDetailLoader.load(url: url) { [weak self] result in
            switch result {
            case let .success(detail):
                self?.loadImage(for: detail)
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
    
    func loadImage(for model: PokemonDetail) {
        task = imageLoader.load(from: model.imageURL, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(imageData):
                self.presenter?.didFinishLoadingImageData(with: imageData, for: model)
            case let .failure(error):
                self.presenter?.didFinishLoadingImageData(with: error, for: model)
            }
        })
    }
    
}
