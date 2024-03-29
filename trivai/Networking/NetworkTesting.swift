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
    @State var numQuestions: Double = 3
    @State var apiCall = false
    
    func call_api() {
        self.quizInfo.title = user_input
        self.apiCall = true
        NetworkManager.createTopicQuestion(topic: user_input, num_questions: Int(numQuestions+0.49)) { questions, success, error in
            if (success) {
                self.apiCall = false
                DispatchQueue.main.async {
                    self.questionListWrapper = QuestionListWrapper(questions: questions ?? [])
                }
            } else {
                print("Error decoding question")
            }
        }
    }
    
    
    var body: some View {
            VStack() {
                VStack {
                    Text("Choose Topic")
                        .font(.system(size:40))
                        .foregroundColor(Color.white)
                        .bold()
                        .padding()
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                        .background(Color("background3"))
                        .frame(maxWidth: .infinity)
                }
                .background(Color("background3"))
                .frame(maxWidth: .infinity)
                
                    
                
                    Spacer()
                VStack {
                    Text("\(numQuestions, specifier: "%.0f") QUESTIONS")
                       .font(.caption)
                       .fontWeight(.bold)
                       .foregroundColor(.gray)
                    Slider(value: $numQuestions, in: 1...10)
                    
                }
                .padding(.leading, 50)
                .padding(.trailing, 50)
                
                    TextField("ENTER TOPIC", text:$user_input)
                        .font(.system(size:25))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .frame(width: 320.0, height: 40.0)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 1.0)
                                .border(Color("background3"))
                        ).padding()
                    
                    
                    Spacer()
                
                VStack {
                    Button (action: {
                        self.call_api()
                    }) {
                        Text("Create Quiz")
                            .font(.system(size:30))
                            .bold()
                            .foregroundColor(Color.white)
                            .frame(width: 340.0, height: 70.0)
                            .background(Color("background4"))
                            .cornerRadius(10)
                            .shadow(radius: 20)
                            .background(Color("background3")).padding(EdgeInsets(top: 30, leading: 10, bottom: 0, trailing: 10))
                            .padding()
                    }.sheet(item: $questionListWrapper) { wrapper in
                        QuestionsView(info: Info(title: self.user_input, peopleAttended: 100, rules: ["Answer the questions carefully"]), questions: wrapper.questions) {
                            // some action
                        }
                    }
                    .sheet(isPresented: $apiCall) {
                        LoadingView()
                    }
                }
                .background(Color("background3")).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                    
                
                }
                
        }
}

#if DEBUG
struct NetworkTesting_Previews: PreviewProvider {
   static var previews: some View {
      NetworkTesting()
   }
}
#endif
