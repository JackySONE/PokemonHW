//
//  PokemonDetailViewController.swift
//  PokemonIOS
//
//  Created by 賴彥宇 on 2022/12/12.
//

import UIKit
import Pokemon

public protocol PokemonDetailViewControllerDelegate {
    func didRequestPokemonDetail()
}

public final class PokemonDetailViewController: UIViewController, PokemonDetailView {
    public typealias Image = UIImage
    
    public var delegate: PokemonDetailViewControllerDelegate?
    
    @IBOutlet private(set) public var idLabel: UILabel!
    @IBOutlet private(set) public var imageView: UIImageView!
    @IBOutlet private(set) public var heightLabel: UILabel!
    @IBOutlet private(set) public var weightLabel: UILabel!
    @IBOutlet private(set) public var propertiesLabel: UILabel!
    @IBOutlet private(set) public var errorView: ErrorView?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate?.didRequestPokemonDetail()
    }
    
    public func display(_ model: PokemonDetailViewModel<UIImage>) {
        idLabel.text = model.id
        imageView.image = model.image
        heightLabel.text = model.height
        weightLabel.text = model.weight
        propertiesLabel.text = model.properties
    }
}
