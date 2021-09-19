//
//  Question.swift
//  ysTrivia
//
//  Created by Ярослав on 17.09.2021.
//

import Foundation
import RealmSwift

class Answer: Object, Codable {
    
    @Persisted var text: String
    @Persisted var correct: Bool
}

class Question: Object, Codable {
    
    @Persisted var difficulty: Int
    @Persisted var text: String
    @Persisted var answers: List<Answer>
}
