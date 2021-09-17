//
//  Question.swift
//  ysTrivia
//
//  Created by Ярослав on 17.09.2021.
//

import Foundation
import RealmSwift

class Answer: Object, Codable {
    @Persisted var answer: String
    @Persisted var correct: Bool
}

class Question: Object, Codable {
    @Persisted var difficulty: Int
    @Persisted var question: String
    @Persisted var answers: List<Answer>
}
