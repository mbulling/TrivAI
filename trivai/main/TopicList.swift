//
//  TopicList.swift
//  trivai
//
//  Created by Mason Bulling on 3/18/23.
//  Copyright © 2023 Mithun. All rights reserved.
//

import Foundation
import SwiftUI
import Alamofire

struct TopicList: View {
    /// - View Properties
    @State private var topicList: [String] = []
    @State private var quizInfo: Info = Info(title: "Testing", peopleAttended: 100, rules: ["Answer the questions carefully"])
    @State private var questionListWrapper: QuestionListWrapper? = nil
    
    func getTopics() {
        AF.request("http://127.0.0.1:5000/topics").responseJSON { response in
            print(response.result)
            switch response.result {
            case .success(let value):
                if let jsonArray = value as? [String] {
                    DispatchQueue.main.async {
                        print(jsonArray);
                        self.topicList = jsonArray
                        
                    }
                } else {
                    print("Failed to decode the response as an array of strings.")
                }
            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if !topicList.isEmpty {
                Text("Your Quizzes")
                    .font(.system(size: 40))
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .padding(.leading, 30)
                    .offset(y: 20)
            }
            
            
                NavigationView {
                    ScrollView(.vertical, showsIndicators: false) {
                    ForEach(topicList, id: \.self) { topic in
                        Button (action: {
                            NetworkManager.createTopicQuestion(topic: topic) { questions, success, error in
                                if (success) {
                                    DispatchQueue.main.async {
                                        self.questionListWrapper = QuestionListWrapper(questions: questions ?? [])
                                    }
                                } else {
                                    print("Error decoding question")
                                }
                            }
                        }) {
                            HStack {
                                Text(topic)
                                    .font(.system(size:30))
                                    .bold()
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity)
                            }
                            .padding()
                            .background(Color("background3"))
                            .cornerRadius(80)
                        }.sheet(item: $questionListWrapper) { wrapper in
                            QuestionsView(info: quizInfo, questions: wrapper.questions) {
                                // some action
                            }
                        }
                    }
                }.background(Color.blue)
                        
            }
            .padding(20)
        }
        .background(Color.blue)
        .onAppear {
            self.getTopics()
        }
    }
}


struct Previews_TopicList_Previews: PreviewProvider {
    static var previews: some View {
        TopicList()
    }
}
