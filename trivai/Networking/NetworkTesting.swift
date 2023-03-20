//
//  NetworkTesting.swift
//  trivai
//
//  Created by Mason Bulling on 3/20/23.
//  Copyright © 2023 Mithun. All rights reserved.
//

import SwiftUI

struct NetworkTesting: View {
    
    @State private var user_input: String = ""
    @State private var questionList: [Question]? = [
        Question(question: "What notation describes a derivative?", options: ["d/dx", "dd", "dxd", "xdx"], answer_id: 0),
        Question(question: "What is the derivative of 2x?", options: ["0", "1", "x", "2"], answer_id: 3),
        ]
    @State private var questionListWrapper: QuestionListWrapper? = nil
    @State private var quizInfo: Info = Info(title: "Testing", peopleAttended: 100, rules: ["Answer the questions carefully"])
    
    var body: some View {
            VStack() {
                TextField("User Input", text: $user_input).textInputAutocapitalization(.never).disableAutocorrection(true).frame(height: 48)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1.0)
                    ).padding()
                Button (action: {
                    NetworkManager.testQuestions { questions, success, error in
                        if (success) {
                            DispatchQueue.main.async {
                                self.questionListWrapper = QuestionListWrapper(questions: questions ?? [])
                            }
                        } else {
                            print("Error decoding question")
                        }
                    }
                }) {
                    Text("Press").font(.system(size: 30)).background(Color.white).foregroundColor(Color("background3")).padding()
                }.sheet(item: $questionListWrapper) { wrapper in
                    QuestionsView(info: quizInfo, questions: wrapper.questions) {
                        // some action
                    }
                }
            }
        }
}

