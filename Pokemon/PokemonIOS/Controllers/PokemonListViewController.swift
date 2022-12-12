//
//  PokemonListViewController.swift
//  PokemonIOS
//
//  Created by 賴彥宇 on 2022/12/12.
//

import UIKit
import Pokemon

protocol PokemonListViewControllerDelegate {
    func didRequestPokemon ()
}

public final class PokemonListViewController: UITableViewController, UITableViewDataSourcePrefetching, PokemonLoadingView, PokemonListErrorView {
    var delegate: PokemonListViewControllerDelegate?
    @IBOutlet private(set) public var errorView: ErrorView?
    
    var tableModel = [PokemonCellController]() {
        didSet { tableView.reloadData() }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    @IBAction private func refresh() {
        delegate?.didRequestPokemon()
    }
    
    public func display(_ viewModel: PokemonLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
    
    public func display(_ viewModel: PokemonListErrorViewModel) {
        if let message = viewModel.message {
            errorView?.show(message: message)
        } else {
            errorView?.hideMessage()
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> PokemonCellController {
        return tableModel[indexPath.row]
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
