//
//  GameCaretaker.swift
//  ysTrivia
//
//  Created by Ярослав on 20.09.2021.
//

import Foundation
import RealmSwift

class GameSessionCaretaker {
    
    lazy var configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true, objectTypes: objectTypes)
    lazy var realm = try! Realm(configuration: configuration)
    
    private let key = "gameinprogress"
    
    func destroy() {
        
        let game = GamePersisted()
        
        game.recordID = key
        
        try! realm.write {
            realm.add(game, update: .all)
            realm.delete(game)
        }
    }
    
    func save(_ gameSession: GameSession) {
        
        let game = GamePersisted()
        
        game.recordID = key
        game.currentQuestionNo = gameSession.currentQuestionNo

        game.isLifelineFiftyUsed = gameSession.isLifelineFiftyUsed
        game.isLifelinePhoneUsed = gameSession.isLifelinePhoneUsed
        game.isLifelineAskAudienceUsed = gameSession.isLifelineAskAudienceUsed
        
        try! realm.write {
            realm.add(game, update: .all)
        }
    }
    
    func load() -> GamePersisted? {
        
        //print(realm.configuration.fileURL!)
        return realm.objects(GamePersisted.self).first
    }
}
