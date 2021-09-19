//
//  GamePersisted.swift
//  ysTrivia
//
//  Created by Ярослав on 20.09.2021.
//

import Foundation
import RealmSwift

class GamePersisted: Object {
    
    @Persisted var recordID: String
    
    @Persisted var currentQuestionNo: Int
    @Persisted var currentQuestion: QuestionPersisted?
    
    @Persisted var isLifelineFiftyUsed: Bool
    @Persisted var isLifelinePhoneUsed: Bool
    @Persisted var isLifelineAskAudienceUsed: Bool
    
    override static func primaryKey() -> String? {
        return "recordID"
    }
}

class QuestionPersisted: Object {
    
    @Persisted var difficulty: Int
    @Persisted var text: String
    @Persisted var answers: List<AnswerPersisted>
}

class AnswerPersisted: Object {
    
    @Persisted var text: String
    @Persisted var correct: Bool
}
