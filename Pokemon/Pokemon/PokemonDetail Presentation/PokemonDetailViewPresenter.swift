//
//  PokemonDetailViewPresenter.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/12.
//

import Foundation

public protocol PokemonDetailView {
    associatedtype Image
    
    func display(_ mode: PokemonDetailViewModel<Image>)
}

public final class PokemonDetailViewPresenter<View: PokemonDetailView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoading() {
        view.display(.showLoading)
    }
    
    public func didFinishLoading(with error: Error) {
      view.display(.showError(message: error.localizedDescription))
    }
    
    public func didStarLoadingImageData(for model: PokemonDetail) {
        view.display(PokemonDetailViewModel(
            id: model.id,
            image: nil,
            height: model.height,
            weight: model.weight,
            types: model.properties.map { $0.name },
            isLoading: true,
            errorMessage: nil)
        )
    }
                     
    private struct InvalidImageDataError: Error {}
    
    public func didFinishLoadingImageData(with data: Data, for model: PokemonDetail) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
        }

        view.display(PokemonDetailViewModel(
            id: model.id,
            image: image,
            height: model.height,
            weight: model.weight,
            types: model.properties.map { $0.name },
            isLoading: false,
            errorMessage: nil)
        )
    }

    public func didFinishLoadingImageData(with error: Error, for model: PokemonDetail) {
        view.display(PokemonDetailViewModel(
            id: model.id,
            image: nil,
            height: model.height,
            weight: model.weight,
            types: model.properties.map { $0.name },
            isLoading: false,
            errorMessage: nil)
        )
    }
                     
}
