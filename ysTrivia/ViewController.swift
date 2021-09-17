//
//  ViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 17.09.2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm(configuration: Realm.Configuration(fileURL: Bundle.main.url(forResource: "triviaDB", withExtension: "realm"), readOnly: true))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questions = realm.objects(Question.self).filter("question contains 'Что'")
        
        questions.forEach { question in
            print(question.question)
        }

        
    }

}

