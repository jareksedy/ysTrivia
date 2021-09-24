//
//  AddQuestionViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 24.09.2021.
//

import UIKit

class AddQuestionViewController: UIViewController {
    
    @IBOutlet weak var addQuestionTextField: UITextField!
    @IBOutlet weak var answer1TextField: UITextField!
    @IBOutlet weak var answer2TextField: UITextField!
    @IBOutlet weak var answer3TextField: UITextField!
    @IBOutlet weak var answer4TextField: UITextField!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    @IBOutlet weak var correctAnswerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addQuestionButton: UIButton!
    
    // MARK: - Array of text fields.
    
    lazy var textFields = [addQuestionTextField, answer1TextField, answer2TextField, answer3TextField, answer4TextField]
    let caretaker = UserQuestionCaretaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func AddQuestionButtonTap(_ sender: Any) {
        
        let allFilled = textFields.map{ $0?.text?.isEmpty ?? true }.filter{ $0 == true }.isEmpty
        
        if allFilled {
            
            let question = UserQuestion()
            var difficulty = 1
            
            switch difficultySegmentedControl.selectedSegmentIndex {
            case 0: difficulty = 1
            case 1: difficulty = 10
            case 2: difficulty = 15
            default: difficulty = 1
            }
            
            question.text = addQuestionTextField.text!
            question.difficulty = difficulty
            
            question.answer1 = answer1TextField.text!
            question.answer2 = answer2TextField.text!
            question.answer3 = answer3TextField.text!
            question.answer4 = answer4TextField.text!

            question.correctIndex = correctAnswerSegmentedControl.selectedSegmentIndex
            
            caretaker.save(question: question)
            
            self.displayAlert(withAlertTitle: "Вопрос сохранен! 👍",
                              andMessage: "Вы можете добавить еще один или вернуться в главное меню.")
            
            self.textFields.forEach { textField in
                textField?.text = ""
            }
            
            
        } else {
            displayAlert(withAlertTitle: "⚠️ Важно! ⚠️", andMessage: "Пожалуйста, 🥺 заполните все поля!")
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
