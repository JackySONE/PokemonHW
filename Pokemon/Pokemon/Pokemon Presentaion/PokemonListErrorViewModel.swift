//
//  PokemonListErrorViewModel.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/12.
//

public struct PokemonListErrorViewModel {
    public let message: String?
    
    static var noError: PokemonListErrorViewModel {
        return PokemonListErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> PokemonListErrorViewModel {
        return PokemonListErrorViewModel(message: message)
    }
}
