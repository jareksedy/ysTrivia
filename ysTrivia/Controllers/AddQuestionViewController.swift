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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func AddQuestionButtonTap(_ sender: Any) {
        
        let allFilled = textFields.map{ $0?.text?.isEmpty ?? true }.filter{ $0 == true }.isEmpty
        
        if allFilled {
            
            print(difficultySegmentedControl.selectedSegmentIndex)
            
        } else {
            displayAlert(withAlertTitle: "⚠️ Важно! ⚠️", andMessage: "Пожалуйста, 🥺 заполните все поля!")
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
