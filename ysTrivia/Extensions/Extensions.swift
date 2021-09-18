//
//  Extensions.swift
//  ysTrivia
//
//  Created by Ярослав on 19.09.2021.
//

import Foundation

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
