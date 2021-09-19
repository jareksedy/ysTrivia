//
//  InitialViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 18.09.2021.
//

import UIKit
import RealmSwift

class InitialViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    let game = Game.shared
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        if game.gameSession == nil { resultLabel.text = "" }
        versionLabel.text = "Верс. \(game.version)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toGameVC" {
            let destination = segue.destination as! GameViewController
            destination.gameDelegate = self
        }
    }
}

extension InitialViewController: GameViewControllerDelegate {
    
    func didEndGame(withResult result: GameSession) {
        
        game.gameSession = result
        
        resultLabel.text = """
        🎮 РЕЗУЛЬТАТ 🧩 ПОСЛЕДНЕЙ ИГРЫ 🏆
        Статус игры: \(game.gameStatus)
        Заработано: \(game.moneyWon) ₽.
        Правильные ответы: \(game.current) из \(game.questionsTotal), \(game.percentage)%.
        
        🧿 ПОДСКАЗКИ 🧿
        50 на 50: \(game.gameSession?.isLifelineFiftyUsed ?? false ? "Да" : "Нет")
        Помощь зала: \(game.gameSession?.isLifelineAskAudienceUsed ?? false ? "Да" : "Нет")
        Звонок другу: \(game.gameSession?.isLifelinePhoneUsed ?? false ? "Да" : "Нет")
        
        Результат 💾 сохранен.
        Сыграем ⚽ еще?
        """
        
    }
}
