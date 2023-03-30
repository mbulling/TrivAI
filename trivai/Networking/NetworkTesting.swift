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
    @State private var questionList: [Question]? = []
    @State private var questionListWrapper: QuestionListWrapper? = nil
    @State private var quizInfo: Info = Info(title: "Testing", peopleAttended: 100, rules: ["Answer the questions carefully"])
    
    var body: some View {
            VStack() {
                Text("Creation").font(.system(size: 50, weight: .bold)).foregroundColor(Color(hex: "#9900ff")).padding()
                Spacer()
                TextField("Input Context", text: $user_input).textInputAutocapitalization(.never).disableAutocorrection(true).frame(height: 48)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1.0)
                    ).padding()
                HStack() {
                    Button (action: {
                        // generate questions from user_input
                        NetworkManager.createTopicQuestion(topic: user_input, completion: { questions, success, error in
                            if (success) {
                                DispatchQueue.main.async {
                                    self.questionListWrapper = QuestionListWrapper(questions: questions ?? [])
                                }
                            } else {
                                print("Error decoding question")
                            }
                        })
                    }) {
                        Text("Create MCQ").font(.system(size: 20)).background(Color.white).foregroundColor(Color("background3")).padding()
                    }.sheet(item: $questionListWrapper) { wrapper in
                        QuestionsView(info: quizInfo, questions: wrapper.questions) {
                            // some action
                        }
                    }
                    Button (action: {
                        // generate questions from user_input
                        NetworkManager.createTFQuestion(user_input: user_input, completion: { questions, success, error in
                            if (success) {
                                DispatchQueue.main.async {
                                    self.questionListWrapper = QuestionListWrapper(questions: questions ?? [])
                                }
                            } else {
                                print("Error decoding question")
                            }
                        })
                    }) {
                        Text("Create T/F Questions").font(.system(size: 20)).background(Color.white).foregroundColor(Color("background3")).padding()
                    }.sheet(item: $questionListWrapper) { wrapper in
                        QuestionsView(info: quizInfo, questions: wrapper.questions) {
                            // some action
                        }
                    }
                }
                
                Spacer()
            }
        }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

