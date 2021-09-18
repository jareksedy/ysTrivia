//
//  InitialViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 18.09.2021.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    let game = Game.shared
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        versionLabel.text = "Верс. \(game.version)"
    }

}
