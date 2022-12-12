//
//  RemotePokemonDetailLoader.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/12.
//

import Foundation

public final class RemotePokemonDetailLoader: PokemonDetailLoader {
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(client: HTTPClient) {
        self.client = client
    }

    public func load(url: URL, completion: @escaping (PokemonDetailLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(PokemonDetailMapper.map(data, with: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
