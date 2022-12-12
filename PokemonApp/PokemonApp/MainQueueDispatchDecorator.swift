//
//  MainQueueDispatchDecorator.swift
//  PokemonApp
//
//  Created by 賴彥宇 on 2022/12/12.
//

import Foundation
import Pokemon

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: PokemonLoader where T == PokemonLoader {
    func load(completion: @escaping (PokemonLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
