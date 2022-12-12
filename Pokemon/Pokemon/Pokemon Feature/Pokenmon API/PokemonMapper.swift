//
//  PokemonMapper.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/11.
//

import Foundation

internal struct PokemonMapper {
    private struct Root: Decodable {
        let count: Int
        let next: URL
        let previous: URL?
        let results: [Item]

        var items: [Pokemon] {
            return results.map { $0.item }
        }
    }

    private struct Item: Decodable {
        let name: String
        let url: URL

        var item: Pokemon {
            return Pokemon(name: name,
                           url: url)
        }
    }

    private static var OK_200: Int { return 200 }

    internal static func map(_ data: Data, with response: HTTPURLResponse) -> PokemonLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemotePokemonLoader.Error.invalidData)
        }

        return .success(root.items)
    }
}
