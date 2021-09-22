//
//  GameViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 18.09.2021.
//

import UIKit

protocol GameViewControllerDelegate: AnyObject {
    func didEndGame(withResult result: GameSession)
}

class Observer {}

class GameViewController: UIViewController {
    
    // MARK: - Aborted game.
    
    var abortedGame: GamePersisted?
    
    // MARK: - Delegates.
    
    weak var gameDelegate: GameViewControllerDelegate?
    
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
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var endGameButton: UIButton!
    
    // MARK: - Array of answer buttons.
    
    lazy var answerButtons = [answerButtonA, answerButtonB, answerButtonC, answerButtonD]
    
    // MARK: - Instances.
    
    let game = Game.shared
    let gameSession = GameSession()
    let questionProvider = QuestionProvider()
    let gameSessionCaretaker = GameSessionCaretaker()
    let observer = Observer()
    
    // MARK: - Properties.
    
    lazy var difficultyIndex: Observable<Int> = Observable(gameSession.currentQuestionNo)
    
    // MARK: - Timer.
    
    var timer: Timer?
    var timerRunCount = 15
    var timerPaused = false
    
    // MARK: - Messages.
    
    let audienceTitle = "🥸🤮 Помощь зала 🥱😫"
    let audienceMessage = "Большинство зрителей в зале считает, что правильный ответ — "
    
    let friendTitle = "🤷🏻‍♂️ Звонок другу 🤷🏻‍♂️"
    let friendMessage = "Извини, приятель, точно не знаю, но больше склоняюсь к варианту "
    
    let endGameTitle = "🤔 Завершить игру? 🤔"
    lazy var endGameMessage = """
        Вы уверены что хотите завершить игру
        и забрать ваш выигрыш
        \(gameSession.earnedMoney.formatted) ₽?
        Вы хорошо подумали?
        """
    
    let gameOverTitle = "👾 Пипец! 👾"
    lazy var gameOverMessage = """
        Сожалею, ответ неверный!
        Ваш выигрыш \(gameSession.earnedMoneyGuaranteed > 0 ? "в размере несгораемого остатка равен \("\n" + gameSession.earnedMoneyGuaranteed.formatted) ₽." : "равен нулю.")
        Игра окончена.
        """
    
    let winTitle = "🙌🏼 Вы выиграли 🙌🏼"
    let winMessage = """
        Поздравляю! Это почти невозможно, но вы выиграли три миллиона рублей!
        Признайтесь честно, жульничали? Гуглили ответы?
        Ладно, так уж и быть, забирайте свой выигрыш.
        """
    
    // MARK: - Private methods.
    
    private func pauseTimer() {
        
        guard game.clockMode else { return }
        guard timer != nil else { return }
        timerPaused = true
        
    }
    
    private func resumeTimer() {
        
        guard game.clockMode else { return }
        guard timer != nil else { return }
        timerPaused = false
    }
    
    private func stopTimer() {
        
        guard game.clockMode else { return }
        guard timer != nil else { return }
        timer!.invalidate()
        timer = nil
    }
    
    private func startTimer() {
        
        guard game.clockMode else { return }
        
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            if self.timerPaused { return }
            
            self.timerLabel.textColor = UIColor.systemPurple
            self.timerLabel.text = "00:" + String(format: "%02d", self.timerRunCount)
            self.timerRunCount -= 1
            
            if self.timerRunCount < 5 {
                self.timerLabel.textColor = .incorrect
            }

            if self.timerRunCount < 0 {
                self.timerRunCount = 0
                self.timerLabel.text = "00:" + String(format: "%02d", self.timerRunCount)
                timer.invalidate()
            }
        }
    }
    
    private func endGame(_ session: GameSession) {
        
        gameDelegate?.didEndGame(withResult: session)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
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
        gameSession.gameStatus = .inProgress
    }
    
    private func restoreGameSession() {
        
        guard let abortedGame = abortedGame else { return }
        
        gameSession.currentQuestionNo = abortedGame.currentQuestionNo
        gameSession.isLifelineFiftyUsed = abortedGame.isLifelineFiftyUsed
        gameSession.isLifelinePhoneUsed = abortedGame.isLifelinePhoneUsed
        gameSession.isLifelineAskAudienceUsed = abortedGame.isLifelineAskAudienceUsed
        gameSession.gameStatus = .inProgress
    }
    
    private func displayQuestion() {
        
        difficultyIndex.value = gameSession.currentQuestionNo
        
        if game.clockMode {
            timerLabel.isHidden = false
            timerRunCount = 15
            startTimer()
        } else {
            timerLabel.isHidden = true
        }
        
        updateButtons()
        
        guard let question = questionProvider.fetchRandom(for: difficultyIndex.value) else { return }
        guard let questionValue = game.payout[difficultyIndex.value] else { return }
        
        currentQuestionValueLabel.text = "\(questionValue.formatted) ₽"
        
        currentQuestionLabel.text = question.text
        
        for (index, answer) in question.answers.enumerated() {
            
            answerButtons[index]?.setTitle(answer.text, for: .normal)
            answerButtons[index]?.backgroundColor = .unanswered
            answerButtons[index]?.alpha = 1.0
            answerButtons[index]?.isEnabled = true
            answerButtons[index]?.isHidden = false
        }
        
        gameSession.currentQuestion = question
    }
    
    private func disableButtons(_ answerIndex: Int) {
        
        lifelineFiftyButton.isEnabled = false
        lifelineFiftyButton.alpha = 0.75
        
        lifelinePhoneButton.isEnabled = false
        lifelinePhoneButton.alpha = 0.75
        
        lifelineAskAudienceButton.isEnabled = false
        lifelineAskAudienceButton.alpha = 0.75
        
        endGameButton.isEnabled = false
        endGameButton.alpha = 0.75
        
        for button in answerButtons {
            button?.isEnabled = false
            button?.alpha = button?.tag != answerIndex ? 0.75 : 1.0
        }
    }
    
    private func isCorrect(_ answerIndex: Int) -> Bool {
        
        return gameSession.currentQuestion?.answers[answerIndex].correct ?? false
    }
    
    private func updateButtons() {
        
        if gameSession.isLifelineFiftyUsed {
            lifelineFiftyButton.isEnabled = false
            lifelineFiftyButton.alpha = 0.75
        } else {
            lifelineFiftyButton.isEnabled = true
            lifelineFiftyButton.alpha = 1.0
        }
        
        if gameSession.isLifelinePhoneUsed {
            lifelinePhoneButton.isEnabled = false
            lifelinePhoneButton.alpha = 0.75
        } else {
            lifelinePhoneButton.isEnabled = true
            lifelinePhoneButton.alpha = 1.0
        }
        
        if gameSession.isLifelineAskAudienceUsed {
            lifelineAskAudienceButton.isEnabled = false
            lifelineAskAudienceButton.alpha = 0.75
        } else {
            lifelineAskAudienceButton.isEnabled = true
            lifelineAskAudienceButton.alpha = 1.0
        }
        
        if gameSession.earnedMoney == 0 {
            
            endGameButton.setTitle("Забрать деньги и завершить игру.", for: .normal)
            endGameButton.isEnabled = false
            endGameButton.alpha = 0.75
            
        } else {
            
            endGameButton.setTitle("Забрать \(gameSession.earnedMoney.formatted) ₽ и завершить игру.", for: .normal)
            endGameButton.isEnabled = true
            endGameButton.alpha = 1.0
        }
    }
    
    // MARK: - Actions.
    
    @objc func answerButtonAction(_ sender: UIButton!) {
        
        stopTimer()
        
        let answerIndex = sender.tag
        
        disableButtons(answerIndex)
        answerButtons[answerIndex]?.backgroundColor = .answered
        
        delay { [self] in
            
            if isCorrect(answerIndex) {
                // ОТВЕТ ВЕРНЫЙ. ИДЕМ ДАЛЬШЕ.
                answerButtons[answerIndex]?.backgroundColor = .correct
                delay {
                    if difficultyIndex.value < game.questionsTotal {
                        nextQuestion()
                    } else {
                        // ИГРА ОКОНЧЕНА. ИГРОК ВЫИГРАЛ МАКСИМАЛЬНУЮ СУММУ.
                        win(answerIndex)
                    }
                }
            } else {
                // ОТВЕТ НЕВЕРНЫЙ. ЗАВЕРШАЕМ ИГРУ.
                gameOver(answerIndex)
            }
        }
    }
    
    @IBAction func lifelineFiftyAction(_ sender: Any) {
        
        guard let firstIndex = gameSession.currentQuestion?.correctIndex else { return }
        let secondIndex = Int.random(in: 0...3, excluding: firstIndex)
        
        lifelineFiftyButton.isEnabled = false
        lifelineFiftyButton.alpha = 0.75
        gameSession.isLifelineFiftyUsed = true
        
        for button in answerButtons {
            
            if button?.tag != firstIndex && button?.tag != secondIndex {
                
                button?.isEnabled = false
                button?.isHidden = true
            }
        }
    }
    
    @IBAction func lifelineAskAudienceAction(_ sender: Any) {
        
        guard let firstIndex = gameSession.currentQuestion?.correctIndex else { return }
        let secondIndex = Int.random(in: 0...3, excluding: firstIndex)
        
        pauseTimer()
        
        var audienceSuggests = 0
        
        if gameSession.isLifelineFiftyUsed { audienceSuggests = firstIndex } else {
            audienceSuggests = Int.random(in: 0...1) == 1 ? firstIndex : secondIndex
        }
        
        lifelineAskAudienceButton.isEnabled = false
        lifelineAskAudienceButton.alpha = 0.75
        gameSession.isLifelineAskAudienceUsed = true
        
        let answer = game.letterForAnswerIndex[audienceSuggests] ?? "Х/З"
        
        delay { [self] in
            displayAlert(withAlertTitle: audienceTitle,
                         andMessage: audienceMessage + "\(answer).") { _ in
                resumeTimer()
            }
        }
    }
    
    @IBAction func lifelinePhoneAction(_ sender: Any) {
        
        guard let firstIndex = gameSession.currentQuestion?.correctIndex else { return }
        let secondIndex = Int.random(in: 0...3, excluding: firstIndex)
        
        pauseTimer()
        
        var friendSuggests = 0
        
        if gameSession.isLifelineFiftyUsed { friendSuggests = firstIndex } else {
            friendSuggests = Int.random(in: 0...1) == 1 ? firstIndex : secondIndex
        }
        
        lifelinePhoneButton.isEnabled = false
        lifelinePhoneButton.alpha = 0.75
        gameSession.isLifelinePhoneUsed = true
        
        let answer = game.letterForAnswerIndex[friendSuggests] ?? "Х/З"
        let answerText = gameSession.currentQuestion?.answers[friendSuggests].text ?? "Х/3"
        
        delay { [self] in
            displayAlert(withAlertTitle: friendTitle,
                         andMessage: friendMessage + "\(answer). \(answerText).") { _ in
                resumeTimer()
            }
        }
    }
    
    @IBAction func endGameAction(_ sender: Any) {
        
        displayYesNoAlert(withAlertTitle: endGameTitle,
                          andMessage: endGameMessage) { _ in
            
            self.gameSession.gameStatus = .abortedByUser
            self.endGame(self.gameSession)
        }
    }
    
    // MARK: - Game lifecycle methods.
    
    func nextQuestion() {
        
        gameSession.currentQuestionNo += 1
        difficultyIndex.value = gameSession.currentQuestionNo
        
        displayQuestion()
        gameSessionCaretaker.save(gameSession)
    }
    
    func gameOver(_ answerIndex: Int) {
        
        answerButtons[answerIndex]?.backgroundColor = .incorrect
        answerButtons[gameSession.currentQuestion!.correctIndex]?.backgroundColor = .correct
        answerButtons[gameSession.currentQuestion!.correctIndex]?.alpha = 1.0
        
        gameSession.gameStatus = .lost
        
        delay { [self] in
            displayAlert(withAlertTitle: gameOverTitle, andMessage: gameOverMessage) { _ in
                self.endGame(self.gameSession)
            }
        }
    }
    
    func win(_ answerIndex: Int) {
        
        answerButtons[answerIndex]?.backgroundColor = .correct
        answerButtons[gameSession.currentQuestion!.correctIndex]?.alpha = 1.0
        
        gameSession.gameStatus = .won
        
        delay { [self] in
            displayAlert(withAlertTitle: winTitle, andMessage: winMessage) { _ in
                self.endGame(self.gameSession)
            }
        }
    }
    
    // MARK: - Observed.
    
    private func subscribe() {
        
        difficultyIndex.addObserver(observer, options: [.initial, .new, .old]) { dI, change in
            self.currentQuestionNoLabel.text = "Вопрос № \(dI) / \(self.game.questionsTotal), \((dI - 1) * 100 / self.game.questionsTotal)% правильных ответов."
        }
    }
    
    // MARK: - View controller methods.
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        subscribe()
        
        abortedGame != nil ? restoreGameSession() : resetGameSession()
        addButtonActions()
        displayQuestion()
    }
}
