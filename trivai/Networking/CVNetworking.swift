//
//  CVNetworking.swift
//  trivai
//
//  Created by Iram Liu on 4/25/23.
//  Copyright © 2023 Mithun. All rights reserved.
//

import SwiftUI

struct CVNetworking: View {
    @State var user_input: String = ""
    @State private var questionListWrapper: QuestionListWrapper? = nil
    @State private var quizInfo: Info = Info(title: "Testing", peopleAttended: 100, rules: ["Answer the questions carefully"])
    @State var numQuestions: Double = 3
    @State var apiCall = false

    func call_api() {
        self.quizInfo.title = user_input
        self.apiCall = true
        //When we get the passages endpoint, we only have to change this part.
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
                    Text("How Many Questions?")
                        .font(.system(size:30))
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
                //Need to style this portion (I'm just putting a preview for now)
                Text("PREVIEW: " + user_input)
                   .font(.caption)
                   .fontWeight(.bold)
                   .foregroundColor(.black)
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
struct CVNetworking_Previews: PreviewProvider {
   static var previews: some View {
      NetworkTesting()
   }
}
#endif
