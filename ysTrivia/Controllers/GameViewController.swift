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
    
    // MARK: - Messages.
    
    let gameOverTitle = "👾 Пипец! 👾"
    lazy var gameOverMessage = """
        Сожалею, ответ неверный!
        Ваш выигрыш в размере несгораемого остатка равен
        \(gameSession.earnedMoneyGuaranteed.formatted) ₽.
        Игра окончена.
        """
    
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
        
        if gameSession.earnedMoney == 0 {
            
            endGameButton.setTitle("Забрать деньги и завершить игру.", for: .normal)
            endGameButton.isEnabled = false
            endGameButton.alpha = 0.75
            
        } else {
            
            endGameButton.setTitle("Забрать \(gameSession.earnedMoney.formatted) ₽ и завершить игру.", for: .normal)
            endGameButton.isEnabled = true
            endGameButton.alpha = 1.0
        }
        
        currentQuestionNoLabel.text = "ВОПРОС [ \(difficultyIndex) / \(game.questionsTotal) ]"
        currentQuestionValueLabel.text = "\(questionValue.formatted) ₽"
        
        currentQuestionLabel.text = question.text
        
        for (index, answer) in question.answers.enumerated() {
            answerButtons[index]?.setTitle(answer.text, for: .normal)
            answerButtons[index]?.backgroundColor = .unanswered
            answerButtons[index]?.alpha = 1.0
            answerButtons[index]?.isEnabled = true
        }
        
        gameSession.currentQuestion = question
    }
    
    private func disableButtons(_ answerIndex: Int) {
        
        
        for button in answerButtons {
            button?.isEnabled = false
            button?.alpha = button?.tag != answerIndex ? 0.75 : 1.0
        }
    }
    
    private func isCorrect(_ answerIndex: Int) -> Bool {
        
        return gameSession.currentQuestion?.answers[answerIndex].correct ?? false
    }
    
    // MARK: - Actions.
    
    @objc func answerButtonAction(_ sender: UIButton!) {
        
        let answerIndex = sender.tag
        
        disableButtons(answerIndex)
        answerButtons[answerIndex]?.backgroundColor = .answered
        
        delay { [self] in
            
            if isCorrect(answerIndex) {
                // ОТВЕТ ВЕРНЫЙ. ИДЕМ ДАЛЬШЕ.
                answerButtons[answerIndex]?.backgroundColor = .correct
                
                delay {
                    if gameSession.currentQuestionNo < game.questionsTotal {
                        nextQuestion()
                    } else {
                        // ИГРА ОКОНЧЕНА. ИГРОК ВЫИГРАЛ МАКСИМАЛЬНУЮ СУММУ.
                        
                    }
                }
            } else {
                // ОТВЕТ НЕВЕРНЫЙ. ЗАВЕРШАЕМ ИГРУ.
                gameOver(answerIndex)
            }
        }
    }
    
    @IBAction func endGameAction(_ sender: Any) {
        
        gameSession.currentQuestionNo < game.questionsTotal ? gameSession.currentQuestionNo += 1 : resetGameSession()
        displayQuestion()
    }
    
    // MARK: - Game lifecycle methods.
    
    func nextQuestion() {
        
        gameSession.currentQuestionNo += 1
        displayQuestion()
    }
    
    func gameOver(_ answerIndex: Int) {
        
        answerButtons[answerIndex]?.backgroundColor = .incorrect
        answerButtons[gameSession.currentQuestion!.correctIndex]?.backgroundColor = .correct
        answerButtons[gameSession.currentQuestion!.correctIndex]?.alpha = 1.0
        
        delay { [self] in
            displayAlert(withAlertTitle: gameOverTitle, andMessage: gameOverMessage) { _ in 
                _ = navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    // MARK: - View controller methods.
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        resetGameSession()
        addButtonActions()
        displayQuestion()
    }
}
