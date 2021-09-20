//
//  GameStats.swift
//  ysTrivia
//
//  Created by Ярослав on 19.09.2021.
//

import Foundation
import RealmSwift

class StatsService {
    
    lazy var configuration = Realm.Configuration(objectTypes: objectTypes)
    lazy var realm = try! Realm(configuration: configuration)
    
    func fetch() -> [GameStats]? {
        
        return Array(realm.objects(GameStats.self))
    }
    
    func fetchLast() -> GameStats? {
        
        return realm.objects(GameStats.self).last
    }
    
    func add(_ data: GameStats) {
        
        try! realm.write {
            realm.add(data)
        }
    }
}
