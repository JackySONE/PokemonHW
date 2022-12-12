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
    
    private lazy var baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var navigationController: UINavigationController = {
        let pokemonLoader = RemotePokemonLoader(url: baseURL, client: httpClient)
        return UINavigationController(
            rootViewController: PokemonListUIComposer.pokemonListComposedWith(
                pokemonLoader: pokemonLoader,
            onSelected: showPokemonDetail)
        )
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        configureWindow()
    }
    
    private func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func showPokemonDetail(for detailURL: URL) {
        let detailLoader = RemotePokemonDetailLoader(client: httpClient)
        let imageDataLoader = RemoteImageDataLoader(client: httpClient)
        let pokemonDetailVC = PokemonDetailUIComposer.pokemonDetailComposedWith(
            url: detailURL,
            pokemonDetailLoader: detailLoader, imageLoader: imageDataLoader)
        navigationController.pushViewController(pokemonDetailVC, animated: true)
    }
}

