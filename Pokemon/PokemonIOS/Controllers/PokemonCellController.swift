//
//  PokemonCellController.swift
//  PokemonIOS
//
//  Created by 賴彥宇 on 2022/12/12.
//

import UIKit
import Pokemon

protocol PokemonCellControllerDelegate {
    func display()
}

final class PokemonCellController: PokemonView {
    private let delegate: PokemonCellControllerDelegate
    private var cell: PokemonCell?
    
    init(delegate: PokemonCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        delegate.display()
        return cell!
    }
    
    func preload() {
        delegate.display()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
    }
    
    func display(_ model: PokemonViewModel) {
        cell?.nameLabel.text = model.name
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
