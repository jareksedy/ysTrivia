//
//  Game.swift
//  ysTrivia
//
//  Created by Ярослав on 18.09.2021.
//

import Foundation

final class Game {
    
    static let shared = Game()
    private init() {}
    
    let version = "1.0.0"
    var gameSession: GameSession?
}
