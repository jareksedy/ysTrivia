//
//  UserQuestionCaretaker.swift
//  ysTrivia
//
//  Created by Ярослав on 24.09.2021.
//

import Foundation
import RealmSwift

class UserQuestionCaretaker {
    
    lazy var configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true, objectTypes: objectTypes)
    lazy var realm = try! Realm(configuration: configuration)
    
    func save(question: UserQuestion) {
        
        try! realm.write {
            realm.add(question)
        }
    }
}
