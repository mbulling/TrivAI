//
//  Question.swift
//  TrivAI
//
//  Created by Lisa Li on 2/23/23.
//

import Foundation

enum QDifficulty {
    case easy, medium, hard, impossible
}

struct Question : Identifiable {
    let id = UUID()
    var prompt:String
    var choices:[String]
    var correctIdx:Int // index of correct answer in [choices]
    var difficulty:QDifficulty
    var topics:[String]
}

struct ExampleQuestion {
    static let demoQuestions = [
        Question(prompt: "What is defined as the instantaneous rate of change?", choices: ["Integral", "Derivative", "Limit", "Slope"], correctIdx: 1, difficulty: .easy, topics:["Math", "Calculus", "Integral"]),
        Question(prompt: "What is the derivative of ln(x)?", choices: ["0", "1", "1/x", "x"], correctIdx: 2, difficulty: .medium, topics:["Math", "Calculus", "Derivative"])
    ]
}
