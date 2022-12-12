//
//  PokemonDetailMapper.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/12.
//

import Foundation

internal struct PokemonDetailMapper {
    private struct Root: Decodable {
        let id: Int
        let sprites: Sprites
        let height: Int
        let weight: Int
        let types: [Properties]

        var result: PokemonDetail {
            return PokemonDetail(id: id,
                                 imageURL: sprites.front_default,
                                 height: height,
                                 weight: weight,
                                 properties: types.map { PokemonDetail.Properties(name: $0.name)})
        }
    }
    
    private struct Sprites: Decodable {
        let front_default: URL
    }
    
    private struct Properties: Decodable {
        let type: Propertiy
        
        var name: String {
            type.name
        }
    }
    
    private struct Propertiy: Decodable {
        let name: String
    }

    private static var OK_200: Int { return 200 }

    internal static func map(_ data: Data, with response: HTTPURLResponse) -> PokemonDetailLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemotePokemonDetailLoader.Error.invalidData)
        }

        return .success(root.result)
    }
}
