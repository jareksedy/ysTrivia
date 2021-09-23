//
//  SettingsViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 22.09.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var switchTimer: UISwitch!
    @IBOutlet weak var hintTimerLabel: UILabel!
    @IBOutlet weak var switchHellmode: UISwitch!
    @IBOutlet weak var hellmodeHintLabel: UILabel!
    
    
    let game = Game.shared
    
    let hintTimerText = """
                        Игра с таймером означает, что время, отведенное на ответ, ограничено. Временное ограничение варьируется в зависимости от сложности вопроса:
                        
                        для вопросов с 1 по 5 — 15 секунд;
                        для вопросов с 6 по 10 — 30 секунд;
                        для вопросов с 11 по 15 — 45 секунд.
                        
                        Если вы не успеваете ответить на вопрос за это время, игра считается проигранной.
                        """
    
    let hellmodeText = "В адском режиме вы отвечаете только на самые сложные вопросы."
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        if game.clockMode {
            switchTimer.isOn = true
            hintTimerLabel.text = hintTimerText
        } else {
            switchTimer.isOn = false
            hintTimerLabel.text = ""
        }
        
        if game.hellMode {
            switchHellmode.isOn = true
            hellmodeHintLabel.text = hellmodeText
        } else {
            switchHellmode.isOn = false
            hellmodeHintLabel.text = ""
        }
    }
    
    @IBAction func timerSwitchChanged(_ sender: Any) {
        
        if switchTimer.isOn {
            game.clockMode = true
            hintTimerLabel.text = hintTimerText
        } else {
            game.clockMode = false
            hintTimerLabel.text = ""
        }
    }
    
    @IBAction func hellmodeSwitchChanged(_ sender: Any) {
        
        if switchHellmode.isOn {
            game.hellMode = true
            hellmodeHintLabel.text = hellmodeText
        } else {
            game.hellMode = false
            hellmodeHintLabel.text = ""
        }
    }
}
