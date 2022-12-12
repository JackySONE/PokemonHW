//
//  PokemonLoader.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/11.
//

import Foundation

public protocol PokemonLoader {
    typealias Result = Swift.Result<[Pokemon], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
