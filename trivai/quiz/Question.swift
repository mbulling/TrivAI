//
//  Question.swift
//  TrivAI
//
//  Created by Mason Bulling on 4/24/2023.
//

import SwiftUI

// MARK: Quiz Question Codable Model
struct Question: Identifiable, Codable{
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

struct QuestionListWrapper: Identifiable{
    var id: UUID = .init()
    var questions: [Question]
    
}
