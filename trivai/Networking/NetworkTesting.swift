//
//  NetworkTesting.swift
//  trivai
//
//  Created by Ken Chiem on 3/14/23.
//  Copyright © 2023 Mithun. All rights reserved.
//

import SwiftUI

struct NetworkTesting: View {
    
    @State private var user_input: String = ""
    @State private var questionList: [Question]?
    @State private var showQuestions = false
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
//                showQuestions = true
                NetworkManager.testQuestions { questions, success, error in
                    if (success) {
                        questionList = questions
                        showQuestions = true
                    } else {
                        print("Error decoding question")
                    }
                }
            }) {
                Text("Press").font(.system(size: 30)).background(Color(hex: 0x000000)).foregroundColor(Color(hex: 0xffffff)).padding()
            }.sheet(isPresented: $showQuestions) {
                if let questions = questionList {
                    QuestionsView(info: quizInfo, questions: questions) {
                        // some action
                    }
                }
            }
        }
    }
}

#if DEBUG
struct NetworkTesting_Previews: PreviewProvider {
   static var previews: some View {
      NetworkTesting()
         .previewDevice("iPhone X")
   }
}
#endif

// Allow hex-codes to be used for Color
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
