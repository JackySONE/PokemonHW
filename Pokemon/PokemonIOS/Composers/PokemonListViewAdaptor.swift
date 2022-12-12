//
//  PokemonListViewAdaptor.swift
//  PokemonIOS
//
//  Created by 賴彥宇 on 2022/12/12.
//

import UIKit
import Pokemon

final class PokemonListViewAdaptor: PokemonListView {
    private weak var controller: PokemonListViewController?
    
    init(controller: PokemonListViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: PokemonListViewModel) {
        controller?.tableModel = viewModel.list.map { model in
            let adapter = PokemonPresentationAdaptor(model: model)
            let view = PokemonCellController(delegate: adapter)
            
            adapter.presenter = PokemonPresenter(pokemonView: WeakRefVirtualProxy(view))
            
            return view
        }
    }
}
