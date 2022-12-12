//
//  PokemonDetailViewModel.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/12.
//

import Foundation

public struct PokemonDetailViewModel<Image> {
    public let id: String?
    public let image: Image?
    public let height: String?
    public let weight: String?
    public let types: [String]?
    
    public var properties: String? {
        guard let types = types else { return "" }
        return types.joined(separator: ",")
    }
    
    public let isLoading: Bool
    public let errorMessage: String?
    
    public init(id: String?, image: Image?, height: String?, weight: String?, types: [String]?, isLoading: Bool, errorMessage: String?) {
        self.id = id
        self.image = image
        self.height = height
        self.weight = weight
        self.types = types
        self.isLoading = isLoading
        self.errorMessage = errorMessage
    }
    
    public static var showLoading: PokemonDetailViewModel<Image> {
        return PokemonDetailViewModel<Image>(id: nil,
                                             image: nil,
                                             height: nil,
                                             weight: nil,
                                             types: nil,
                                             isLoading: true,
                                             errorMessage: nil)
    }
    
    public static func showError(message: String?) -> PokemonDetailViewModel<Image> {
        return PokemonDetailViewModel<Image>(id: nil,
                                             image: nil,
                                             height: nil,
                                             weight: nil,
                                             types: nil,
                                             isLoading: false,
                                             errorMessage: message)
    }
}
