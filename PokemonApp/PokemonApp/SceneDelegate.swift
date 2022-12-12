//
//  SceneDelegate.swift
//  PokemonApp
//
//  Created by 賴彥宇 on 2022/12/12.
//

import UIKit
import Pokemon
import PokemonIOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let pokemonLoader = RemotePokemonLoader(url: url, client: client)
        
        let pokemonListViewController = PokemonListUIComposer.pokemonListComposedWith(pokemonLoader: pokemonLoader)
        
        window?.rootViewController = pokemonListViewController
    }

}

