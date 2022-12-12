//
//  PokemonDetail.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/12.
//

import Foundation

public struct PokemonDetail: Hashable {
    public let id: Int
    public let imageURL: URL
    public let height: Int
    public let weight: Int
    public let properties: [Poperties]

    public struct Poperties: Hashable {
        public let name: String
    }
    
    public init(id: Int, imageURL: URL, height: Int, weight: Int, properties: [PokemonDetail.Poperties]) {
        self.id = id
        self.imageURL = imageURL
        self.height = height
        self.weight = weight
        self.properties = properties
    }
}
