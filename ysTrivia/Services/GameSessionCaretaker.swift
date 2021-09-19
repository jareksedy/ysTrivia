//
//  GameCaretaker.swift
//  ysTrivia
//
//  Created by Ярослав on 20.09.2021.
//

import Foundation
import RealmSwift

class GameSessionCaretaker {
    
    lazy var configuration = Realm.Configuration(objectTypes: [GameStats.self, GamePersisted.self, QuestionPersisted.self, AnswerPersisted.self])
    lazy var realm = try! Realm(configuration: configuration)
    
    private let key = "gameinprogress"
    
    func destroy() throws {
    }
    
    func save(_ gameSession: GameSession) {
        
        let game = GamePersisted()
        
        game.recordID = key
        game.currentQuestionNo = gameSession.currentQuestionNo
        
        game.isLifelineFiftyUsed = gameSession.isLifelineFiftyUsed
        game.isLifelinePhoneUsed = gameSession.isLifelinePhoneUsed
        game.isLifelineAskAudienceUsed = gameSession.isLifelineAskAudienceUsed
        
        game.currentQuestion?.difficulty = gameSession.currentQuestion?.difficulty ?? 0
        game.currentQuestion?.text = gameSession.currentQuestion?.text ?? "noo"
        
        if let count = gameSession.currentQuestion?.answers.count {
            
            for i in 0...count {
                
                game.currentQuestion?.answers[i].text = gameSession.currentQuestion?.answers[i].text ?? ""
                game.currentQuestion?.answers[i].correct = gameSession.currentQuestion?.answers[i].correct ?? false
            }
        }
        
        try! realm.write {
            realm.add(game, update: .all)
        }
    }
    
    func load() -> GameSession? {
        
        return nil
    }
}
