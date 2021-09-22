//
//  SettingsViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 22.09.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var switchTimer: UISwitch!
    @IBOutlet weak var hintLabel: UILabel!
    
    let game = Game.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        switchTimer.isOn = game.clockMode
        hintLabel.isHidden = !game.clockMode
    }
    
    @IBAction func timerSwitchChanged(_ sender: Any) {
        
        if switchTimer.isOn {
            hintLabel.isHidden = false
            game.clockMode = true
        } else {
            hintLabel.isHidden = true
            game.clockMode = false
        }
    }
}
