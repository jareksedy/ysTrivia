//
//  UserQuestion.swift
//  ysTrivia
//
//  Created by Ярослав on 24.09.2021.
//

import Foundation
import RealmSwift

class UserAnswer: Object {
    
    @Persisted var text: String
    @Persisted var correct: Bool
}

class UserQuestion: Object {
    
    @Persisted var difficulty: Int
    @Persisted var text: String
    @Persisted var answers: List<UserAnswer>
}
