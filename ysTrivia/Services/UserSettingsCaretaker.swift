//
//  UserSettingsCaretaker.swift
//  ysTrivia
//
//  Created by Ярослав on 23.09.2021.
//

import Foundation
import RealmSwift

class UserSettingsCaretaker {
    
    lazy var configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true, objectTypes: objectTypes)
    lazy var realm = try! Realm(configuration: configuration)
    
    private let key = "usersettings"
    
    func save() {
        
        let settings = UserSettings()
        let game = Game.shared
        
        settings.recordID = key
        settings.clockMode = game.clockMode
        settings.hellMode = game.hellMode
        settings.userQuestionMode = game.userQuestionMode
        
        try! realm.write {
            realm.add(settings, update: .all)
        }
    }
    
    func load() {
        
        let game = Game.shared
        
        if let settings = realm.objects(UserSettings.self).first {
            game.clockMode = settings.clockMode
            game.hellMode = settings.hellMode
            game.userQuestionMode = settings.userQuestionMode
        } else {
            return
        }
    }
}
