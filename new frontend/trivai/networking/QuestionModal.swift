//
//  QuestionModal.swift
//  trivai
//
//  Created by Ken Chiem on 3/13/23.
//  Copyright © 2023 Mithun. All rights reserved.
//

import Foundation

struct QuestionModal: Codable {
    var id: UUID = .init()
    var statement : String
    var options : [String]
    var answer_idx : Int
}
