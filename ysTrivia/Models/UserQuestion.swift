//
//  UserQuestion.swift
//  ysTrivia
//
//  Created by Ярослав on 24.09.2021.
//

import Foundation
import RealmSwift

class UserQuestion: Object {
    
    @Persisted var difficulty: Int
    @Persisted var text: String
    @Persisted var answer1: String
    @Persisted var answer2: String
    @Persisted var answer3: String
    @Persisted var answer4: String
    
    @Persisted var correctIndex: Int

}
