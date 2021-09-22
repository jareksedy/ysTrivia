//
//  SettingsViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 22.09.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var switchTimer: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
    }
    
}
