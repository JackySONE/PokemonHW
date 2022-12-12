//
//  PokemonListViewAdaptor.swift
//  PokemonIOS
//
//  Created by 賴彥宇 on 2022/12/12.
//

import UIKit
import Pokemon
import PokemonIOS

final class PokemonListViewAdaptor: PokemonListView {
    private weak var controller: PokemonListViewController?
    private let onSelected: (URL) -> Void
    
    init(controller: PokemonListViewController, onSelected: @escaping (URL) -> Void) {
        self.controller = controller
        self.onSelected = onSelected
    }
    
    func display(_ viewModel: PokemonListViewModel) {
        controller?.tableModel = viewModel.list.map { model in
            let adapter = PokemonPresentationAdaptor(model: model)
            let view = PokemonCellController(delegate: adapter)
            
            view.didSelect = { [weak self] in
                self?.onSelected(model.url)
            }
            
            adapter.presenter = PokemonPresenter(pokemonView: WeakRefVirtualProxy(view))
            
            return view
        }
    }
}
