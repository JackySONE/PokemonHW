//
//  HTTPClient.swift
//  Pokemon
//
//  Created by 賴彥宇 on 2022/12/11.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url: URL, completion: @escaping (Result) -> Void)
}
