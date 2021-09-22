//
//  InitialViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 18.09.2021.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    let game = Game.shared
    let statsService = StatsService()
    let gameSessionCaretaker = GameSessionCaretaker()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        resultLabel.font = UIFont.monospacedSystemFont(ofSize: 10.0, weight: UIFont.Weight.regular)
        
        if game.gameSession == nil { resultLabel.text = "" }
        
        if let lastStats = statsService.fetchLast() {
            resultLabel.text = lastStats.text.uppercased()
        }
        
        if let _ = gameSessionCaretaker.load() {
            
            self.displayYesNoAlert(withAlertTitle: "🚩 Опаньки! 🚩", andMessage: "Найдена незавершенная игра. Возобновить?") { _ in
                
                self.performSegue(withIdentifier: "toGameVC", sender: self)
            }
        }
        
        versionLabel.text = "Верс. \(game.version)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toGameVC" {
            
            let destination = segue.destination as! GameViewController
            destination.gameDelegate = self

            if let abortedGame = gameSessionCaretaker.load() {
                destination.abortedGame = abortedGame
            }
        }
    }
}

extension InitialViewController: GameViewControllerDelegate {
    
    func didEndGame(withResult result: GameSession) {
        
        game.gameSession = result
        
        let data = GameStats()
        
        data.correctAnswerCount = game.current
        data.percentage = game.percentage
        
        data.isLifelineFiftyUsed = game.gameSession?.isLifelineFiftyUsed ?? false
        data.isLifelineAskAudienceUsed = game.gameSession?.isLifelineAskAudienceUsed ?? false
        data.isLifelinePhoneUsed = game.gameSession?.isLifelinePhoneUsed ?? false
        
        data.moneyWon = game.moneyWon
        
        if game.gameSession?.gameStatus == .lost {
            
            data.fatalQuestion = game.gameSession?.currentQuestion?.text
            data.correctAnswer = game.gameSession?.currentQuestion?.answers[game.gameSession?.currentQuestion?.correctIndex ?? 0].text
        }
        
        data.gameStatus = game.gameStatus
        data.gameDate = String(describing: NSDate.now)
        
        statsService.add(data)
        game.gameSession = nil
        
        gameSessionCaretaker.destroy()
        
        resultLabel.text = data.text.uppercased()
    }
}
