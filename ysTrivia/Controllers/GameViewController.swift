//
//  GameViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 18.09.2021.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Outlets.

    @IBOutlet weak var currentQuestionNoLabel: UILabel!
    @IBOutlet weak var currentQuestionValueLabel: UILabel!
    @IBOutlet weak var currentQuestionLabel: UILabel!
    
    @IBOutlet weak var answerButtonA: UIButton!
    @IBOutlet weak var answerButtonB: UIButton!
    @IBOutlet weak var answerButtonC: UIButton!
    @IBOutlet weak var answerButtonD: UIButton!
    
    @IBOutlet weak var lifelineFiftyButton: UIButton!
    @IBOutlet weak var lifelineAskAudienceButton: UIButton!
    @IBOutlet weak var lifelinePhoneButton: UIButton!
    
    @IBOutlet weak var endGameButton: UIButton!
    
    // MARK: - Array of answer buttons.
    
    lazy var answerButtons = [answerButtonA, answerButtonB, answerButtonC, answerButtonD]
    
    // MARK: - Instances.
    
    let game = Game.shared
    let gameSession = GameSession()
    let questionProvider = QuestionProvider()
    
    // MARK: - Private methods.
    
    private func addButtonActions() {
        
        for button in answerButtons {
            button?.addTarget(self, action: #selector(answerButtonAction), for: .touchUpInside)
        }
    }
    
    private func resetGameSession() {
        
        gameSession.currentQuestionNo = 1
        gameSession.isLifelineFiftyUsed = false
        gameSession.isLifelinePhoneUsed = false
        gameSession.isLifelineAskAudienceUsed = false
    }
    
    private func displayQuestion() {
        
        let difficultyIndex = gameSession.currentQuestionNo
        
        guard let question = questionProvider.fetchRandom(for: difficultyIndex) else { return }
        guard let questionValue = game.payout[difficultyIndex] else { return }
        
        currentQuestionNoLabel.text = "ВОПРОС [ \(difficultyIndex) / \(game.questionsTotal) ]"
        currentQuestionValueLabel.text = "\(questionValue.formatted) ₽"
        
        currentQuestionLabel.text = question.text
        
        for (index, answer) in question.answers.enumerated() {
            answerButtons[index]?.setTitle(answer.text, for: .normal)
        }
        
        gameSession.currentQuestion = question
    }
    
    // MARK: - Actions.
    
    @objc func answerButtonAction(_ sender: UIButton!) {
        
        print("Button \(sender.tag) tapped!")
     }
    
    @IBAction func endGameAction(_ sender: Any) {
        
        gameSession.currentQuestionNo < game.questionsTotal ? gameSession.currentQuestionNo += 1 : resetGameSession()
        displayQuestion()
    }
    
    // MARK: - View controller methods.
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        resetGameSession()
        addButtonActions()
        displayQuestion()
    }
}
