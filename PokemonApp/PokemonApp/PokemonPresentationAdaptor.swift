//
//  PokemonPresentationAdaptor.swift
//  PokemonIOS
//
//  Created by 賴彥宇 on 2022/12/12.
//

import Pokemon
import PokemonIOS

final class PokemonPresentationAdaptor: PokemonCellControllerDelegate {
    private let model: Pokemon
    
    var presenter: PokemonPresenter?
    
    init(model: Pokemon) {
        self.model = model
    }
    
    func display() {
        presenter?.display(with: model)
    }
}
