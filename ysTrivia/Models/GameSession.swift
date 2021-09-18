//
//  GameSession.swift
//  ysTrivia
//
//  Created by Ярослав on 18.09.2021.
//

import Foundation
import RealmSwift

class GameSession: Object {
    
    @Persisted var currentQuestionNo: Int
    
    @Persisted var isLifelineFiftyUsed: Bool
    @Persisted var isLifelinePhoneUsed: Bool
    @Persisted var isLifelineAskAudienceUsed: Bool
    
    @Persisted var currentQuestion: Question?
}
