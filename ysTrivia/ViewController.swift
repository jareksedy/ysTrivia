//
//  ViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 17.09.2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    let questionProvider = QuestionProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let question = questionProvider.fetchRandom(for: 5) else { return }
        
        print("Q: \(question.question)")
        print("D: \(question.difficulty)")
        print()
        
        question.answers.forEach { answer in
            print("A[\(answer.correct ? "+" : "-")]: \(answer.answer)")
        }
        
        print()
    }

}

