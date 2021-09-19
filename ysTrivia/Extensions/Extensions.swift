//
//  Extensions.swift
//  ysTrivia
//
//  Created by Ярослав on 19.09.2021.
//

import Foundation
import UIKit

// MARK: - Форматирование целого числа с разбивкой по разрядам в соотв. с русской локалью.

extension Int {
    
    var formatted: String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "RU")
        
        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number)!
        return "\(formattedValue)"
    }
}

// MARK: - Correct answer index.

extension Question {
    
    var correctIndex: Int {
        
        return self.answers.firstIndex(where:  { $0.correct }) ?? 0
    }
}

// MARK: - Colors.

extension UIColor {
    
    static var unanswered: UIColor { return .systemIndigo }
    static var answered: UIColor { return .systemOrange }
    static var correct: UIColor { return .systemGreen }
    static var incorrect: UIColor { return .systemPink }
}

// MARK: - Delay function.

func delay(closure: @escaping ()->()) {
    
    let game = Game.shared
    let when = DispatchTime.now() + game.delayInterval
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
