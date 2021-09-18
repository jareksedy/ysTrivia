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
    
    let questionValues = [
        1: 500,
        2: 1_000,
        3: 2_000,
        4: 3_000,
        5: 5_000,
        6: 10_000,
        7: 15_000,
        8: 25_000,
        9: 50_000,
        10: 100_000,
        11: 200_000,
        12: 400_000,
        13: 800_000,
        14: 1_500_000,
        15: 3_000_000,
    ]
    
    var gameSession: GameSession?
}
