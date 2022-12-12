//
//  Pokemon.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/11.
//

import Foundation

public struct Pokemon: Hashable {
    public let name: String
    public let url: URL
    
    public init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}
