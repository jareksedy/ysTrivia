//
//  ViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 17.09.2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()
    let question = Question()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            let url = URL(string: "/Users/jareksedy/Downloads/triviaDB.realm")
        
        try! realm.writeCopy(toFile: url!)
        
    }
    
}

