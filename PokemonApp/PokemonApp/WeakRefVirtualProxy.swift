//
//  WeakRefVirtualProxy.swift
//  PokemonIOS
//
//  Created by 賴彥宇 on 2022/12/12.
//

import UIKit
import Pokemon

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: PokemonView where T: PokemonView {
    func display(_ model: PokemonViewModel) {
        object?.display(model)
    }
}

extension WeakRefVirtualProxy: PokemonLoadingView where T: PokemonLoadingView {
    func display(_ viewModel: PokemonLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: PokemonListErrorView where T: PokemonListErrorView {
    func display(_ viewModel: PokemonListErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: PokemonDetailView where T: PokemonDetailView, T.Image == UIImage {
    func display(_ model: PokemonDetailViewModel<UIImage>) {
        object?.display(model)

    }
}
