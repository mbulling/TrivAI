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
        AF.request("").responseJSON { response in
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
                    .foregroundColor(Color.black)
                    .padding(.leading, 30)
                    .offset(y: 20)
            }
            NavigationView {
               List {
                   ForEach(topicList, id: \.self) { topic in
                        HStack(spacing: 12.0) {
//                           Image(item.image)
//                              .resizable()
//                              .aspectRatio(contentMode: .fit)
//                              .frame(width: 80, height: 80)
//                              .background(Color("background"))
//                              .cornerRadius(20)
                            Button (action: {
                                NetworkManager.createTopicQuestion(topic: topic, num_questions: 3) { questions, success, error in
                                    if (success) {
                                        DispatchQueue.main.async {
                                            self.questionListWrapper = QuestionListWrapper(questions: questions ?? [])
                                        }
                                    } else {
                                        print("Error decoding question")
                                    }
                                }
                            }) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(topic)
                                           .font(.system(size: 30))
                                         
                                         Spacer()
                                        
                                         Text("HARD")
                                            .lineLimit(2)
                                            .lineSpacing(4)
                                            .font(.subheadline)
                                            .frame(height: 50.0)
                                    }
                                   

                                    Text("3 QUESTIONS")
                                       .font(.caption)
                                       .fontWeight(.bold)
                                       .foregroundColor(.gray)
                                    
        
                                .cornerRadius(80)
                            }.sheet(item: $questionListWrapper) { wrapper in
                                QuestionsView(info: quizInfo, questions: wrapper.questions) {
                                    // some action
                                }
                            }

                           

                              
                           }
                        }
                     }
                     .padding(.vertical, 8.0)
                  }
                  //.onDelete { index in
                     //self.store.updates.remove(at: index.first!)
                  //}
                  //.onMove(perform: move)
               }
               //.navigationBarTitle(Text("Your Quizzes"))
               .navigationBarItems(
                  //leading: Button(action: addUpdate) { Text("Add Update") },
                  trailing: EditButton()
               )
            }

            
            
        
                        
           
        
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
