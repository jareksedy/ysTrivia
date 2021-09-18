//
//  ViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 17.09.2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tapMeButton: UIButton!
    
    let questionProvider = QuestionProvider()
    
    @IBAction func tapMeButtonTap(_ sender: Any) {
        
        let difficulty = 14

        guard let question = questionProvider.fetchRandom(for: difficulty) else { return }
        guard let count = questionProvider.numberOfQuestions(for: difficulty) else { return }

        print("Q: \(question.text)")
        print("D: \(question.difficulty). COUNT: \(count)")
        print()

        question.answers.forEach { answer in
            print("A[\(answer.correct ? "+" : "-")]: \(answer.text)")
        }

        print()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

