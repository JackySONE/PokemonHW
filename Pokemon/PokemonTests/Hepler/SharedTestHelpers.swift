//
//  SharedTestHelpers.swift
//  PokemonTests
//
//  Created by 賴彥宇 on 2022/12/11.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}
