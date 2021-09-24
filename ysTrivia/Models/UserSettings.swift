//
//  UserSettings.swift
//  ysTrivia
//
//  Created by Ярослав on 23.09.2021.
//

import Foundation
import RealmSwift

class UserSettings: Object {

    @Persisted var recordID: String

    @Persisted var clockMode: Bool
    @Persisted var hellMode: Bool
    @Persisted var userQuestionMode: Bool

    override static func primaryKey() -> String? {
        return "recordID"
    }
}
