//
//  ViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 17.09.2021.
//

import UIKit
import SQLite
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let difficulty = Expression<Int>("Difficulty")
        let questionString = Expression<String>("Question")
        let answer1 = Expression<String>("Answer1")
        let answer2 = Expression<String>("Answer2")
        let answer3 = Expression<String>("Answer3")
        let answer4 = Expression<String>("Answer4")
        let correctAnswer = Expression<Int>("Correct")
        
        print("Loading SQLite Database.")
        
        do {
            
            let db = try Connection("Users/jareksedy/Downloads/Rus.sqlite")
            let questions = Table("questions")
            
            let count = try db.scalar(questions.count)
            
            print("Questions count = \(count)")
            
            for question in try db.prepare(questions) {
                
                let questionRealm = Question()
                let ans1 = Answer()
                let ans2 = Answer()
                let ans3 = Answer()
                let ans4 = Answer()
                
                questionRealm.difficulty = question[difficulty]
                questionRealm.question = question[questionString]
                
                ans1.answer = question[answer1]
                ans1.correct = question[correctAnswer] == 1 ? true : false
                questionRealm.answers.append(ans1)
                
                ans2.answer = question[answer2]
                ans2.correct = question[correctAnswer] == 2 ? true : false
                questionRealm.answers.append(ans2)
                
                ans3.answer = question[answer3]
                ans3.correct = question[correctAnswer] == 3 ? true : false
                questionRealm.answers.append(ans3)
                
                ans4.answer = question[answer4]
                ans4.correct = question[correctAnswer] == 4 ? true : false
                questionRealm.answers.append(ans4)

                try! realm.write {
                    realm.add(questionRealm)
                }
                
//                print("Q[\(questionRealm.difficulty)]: \(questionRealm.question)")
//
//                questionRealm.answers.forEach{ answer in
//                    print("A[\(answer.correct ? "+" : " ")]: \(answer.answer)")
//                }
//
//                print()
                
            }
            
        } catch { print(error) }
        
        print("Converting to Realm done!")
    }
    
    
}

