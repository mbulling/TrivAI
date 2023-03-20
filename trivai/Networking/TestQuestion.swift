//
//  TestQuestion.swift
//  trivai
//
//  Created by Ken Chiem on 3/19/23.
//  Copyright © 2023 Mithun. All rights reserved.
//

import Foundation

// MARK: Quiz Question Codable Model
struct TestQuestion: Identifiable, Codable{
    var id: UUID = .init()
    var question: String
    var options: [String]
    var answer_id: Int
    
    /// - For UI State Updates
    var tappedAnswer: String = ""
    
    enum CodingKeys: CodingKey {
        case question
        case options
        case answer_id
    }
}

