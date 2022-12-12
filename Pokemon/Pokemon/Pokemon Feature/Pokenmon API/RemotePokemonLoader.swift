//
//  RemotePokemonLoader.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/11.
//

import Foundation

public final class RemotePokemonLoader: PokemonLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (PokemonLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(PokemonMapper.map(data, with: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
