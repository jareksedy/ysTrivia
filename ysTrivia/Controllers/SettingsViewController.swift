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
    @IBOutlet weak var usermodeHintLabel: UILabel!
    @IBOutlet weak var switchUserQuestionMode: UISwitch!
    
    
    let game = Game.shared
    let userSettingsCaretaker = UserSettingsCaretaker()
    
    let hintTimerText = """
                        Игра с таймером означает, что время, отведенное на ответ, ограничено. Временное ограничение варьируется в зависимости от сложности вопроса:
                        
                        для вопросов с 1 по 5 — 15 секунд;
                        для вопросов с 6 по 10 — 30 секунд;
                        для вопросов с 11 по 15 — 45 секунд.
                        
                        Если вы не успеваете ответить на вопрос за это время, игра считается проигранной.
                        """
    
    let hellmodeText = "В адском режиме вы отвечаете только на самые сложные вопросы."
    
    let usermodeText = "Добавленные вами вопросы будут отображаться в игре наряду с уже существующими в общей базе вопросами."
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        let questionProvider = QuestionProvider(strategy: UserQuestionsStrategy())
        if questionProvider.fetchRandom(for: 1) == nil {
            game.userQuestionMode = false
            switchUserQuestionMode.isEnabled = false
        } else {
            switchUserQuestionMode.isEnabled = true
        }
        
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
        
        if game.userQuestionMode {
            switchUserQuestionMode.isEnabled = true
            usermodeHintLabel.text = usermodeText
        } else {
            switchUserQuestionMode.isOn = false
            usermodeHintLabel.text = ""
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
        
        userSettingsCaretaker.save()
    }
    
    @IBAction func hellmodeSwitchChanged(_ sender: Any) {
        
        if switchHellmode.isOn {
            game.hellMode = true
            hellmodeHintLabel.text = hellmodeText
        } else {
            game.hellMode = false
            hellmodeHintLabel.text = ""
        }
        
        userSettingsCaretaker.save()
    }
    
    @IBAction func userQuestionSwitchChanged(_ sender: Any) {
        
        if switchUserQuestionMode.isOn {
            game.userQuestionMode = true
            usermodeHintLabel.text = usermodeText
        } else {
            game.userQuestionMode = false
            usermodeHintLabel.text = ""
        }
        
        userSettingsCaretaker.save()
    }
}
