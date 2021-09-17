//
//  Question.swift
//  ysTrivia
//
//  Created by Ярослав on 17.09.2021.
//

import Foundation
import RealmSwift

class Question: Object, Codable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var difficulty: Int
    @Persisted var question: String
    @Persisted var answer1: String
    @Persisted var answer2: String
    @Persisted var answer3: String
    @Persisted var answer4: String
    @Persisted var correctAnswer: Int
}
