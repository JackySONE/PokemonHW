//
//  PokemonDetailLoader.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/12.
//

import Foundation

public protocol PokemonDetailLoader {
    typealias Result = Swift.Result<[PokemonDetail], Error>
    
    func load(url: URL, completion: @escaping (Result) -> Void)
}
