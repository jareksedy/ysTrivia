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
    
    // MARK: - Instances.
    
    let game = Game.shared
    let gameSession = GameSession()
    let questionProvider = QuestionProvider()
    
    // MARK: - Private methods.
    
    private func resetGameSession() {
        
        gameSession.currentQuestionNo = 1
        gameSession.isLifelineFiftyUsed = false
        gameSession.isLifelinePhoneUsed = false
        gameSession.isLifelineAskAudienceUsed = false
    }
    
    private func displayQuestion() {
        
        guard let question = questionProvider.fetchRandom(for: gameSession.currentQuestionNo) else { return }
        guard let questionValue = game.questionValues[gameSession.currentQuestionNo] else { return }
        
        currentQuestionNoLabel.text = "ВОПРОС [ \(gameSession.currentQuestionNo) / \(game.questionsCount) ]"
        currentQuestionValueLabel.text = "\(questionValue) ₽"
        
        currentQuestionLabel.text = question.text
        
        answerButtonA.setTitle(question.answers[0].text, for: .normal)
        answerButtonB.setTitle(question.answers[1].text, for: .normal)
        answerButtonC.setTitle(question.answers[2].text, for: .normal)
        answerButtonD.setTitle(question.answers[3].text, for: .normal)
        
    }
    
    // MARK: - Actions.
    
    @IBAction func endGameAction(_ sender: Any) {
        
        gameSession.currentQuestionNo < game.questionsCount ? gameSession.currentQuestionNo += 1 : resetGameSession()
        displayQuestion()
    }
    
    // MARK: - View controller methods.
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        resetGameSession()
        displayQuestion()
        
    }
}
