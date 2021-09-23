//
//  QuestionProvider.swift
//  ysTrivia
//
//  Created by Ярослав on 18.09.2021.
//

import Foundation
import RealmSwift

protocol QuestionStrategy {
    
    func fetchRandom(for difficulty: Int) -> Question?
}

class QuestionProvider {
    
    var strategy: QuestionStrategy
    
    init(strategy: QuestionStrategy) {
        self.strategy = strategy
    }
    
    func fetchRandom(for difficulty: Int) -> Question? {
        strategy.fetchRandom(for: difficulty)
    }
}

class NormalStrategy: QuestionStrategy {
    
    lazy var dbUrl = Bundle.main.url(forResource: "triviaDB", withExtension: "realm")
    lazy var configuration = Realm.Configuration(fileURL: dbUrl, readOnly: true, objectTypes: [Question.self, Answer.self])
    lazy var realm = try! Realm(configuration: configuration)
    
    func fetchRandom(for difficulty: Int) -> Question? {
        let questions = realm.objects(Question.self).filter("difficulty == \(difficulty)")
        return questions.count > 0 ? questions[Int.random(in: 0...questions.count - 1)] : nil
    }
}

class HellmodeStrategy: QuestionStrategy {
    
    lazy var dbUrl = Bundle.main.url(forResource: "triviaDB", withExtension: "realm")
    lazy var configuration = Realm.Configuration(fileURL: dbUrl, readOnly: true, objectTypes: [Question.self, Answer.self])
    lazy var realm = try! Realm(configuration: configuration)
    
    func fetchRandom(for difficulty: Int) -> Question? {
        let questions = realm.objects(Question.self).filter("difficulty == 15 OR difficulty == 14 OR difficulty == 13")
        return questions.count > 0 ? questions[Int.random(in: 0...questions.count - 1)] : nil
    }
}
