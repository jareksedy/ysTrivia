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

class UserQuestionsStrategy: QuestionStrategy {

    lazy var configuration = Realm.Configuration(objectTypes: objectTypes)
    lazy var realm = try! Realm(configuration: configuration)
    
    func fetchRandom(for difficulty: Int) -> Question? {
        
        let userQuestions = realm.objects(UserQuestion.self)
        guard userQuestions.count > 0 else { return nil }
        
        let randomUserQuestion = userQuestions[Int.random(in: 0...userQuestions.count - 1)]
        let question = Question()
        
        question.text = randomUserQuestion.text
        question.difficulty = randomUserQuestion.difficulty
        
        question.answers[0].text = randomUserQuestion.answer1
        question.answers[0].correct = false
        
        question.answers[1].text = randomUserQuestion.answer2
        question.answers[1].correct = false
        
        question.answers[2].text = randomUserQuestion.answer2
        question.answers[2].correct = false
        
        question.answers[3].text = randomUserQuestion.answer3
        question.answers[3].correct = false
        
        question.answers[randomUserQuestion.correctIndex].correct = true
        
        return question
    }
}
