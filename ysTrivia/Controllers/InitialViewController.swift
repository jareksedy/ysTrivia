//
//  InitialViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 18.09.2021.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let game = Game.shared
        versionLabel.text = "Верс. \(game.version)"
    }

}
