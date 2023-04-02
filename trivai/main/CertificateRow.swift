//
//  CertificateRow.swift
//  TrivAI
//
//  Created by Ryan Ho on 03/04/23.
//

import SwiftUI
import Alamofire

struct CertificateRow: View {

    @State private var topicList: [String] = []
    @State private var quizInfo: Info = Info(title: "Testing", peopleAttended: 100, rules: ["Answer the questions carefully"])
    @State private var questionListWrapper: QuestionListWrapper? = nil
    @State private var loading = false
    @State private var pageLoad = false
    
    func getTopics() {
        self.pageLoad = true
        AF.request("http://127.0.0.1:3000/topics").responseJSON { response in
            print(response.result)
            self.pageLoad = false
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
    
    func makeQuestions(topic: String, num_questions: Int) {
        self.quizInfo.title = topic
        self.loading = true
        NetworkManager.createTopicQuestion(topic: topic, num_questions: 3) { questions, success, error in
            if (success) {
                self.loading = false
                DispatchQueue.main.async {
                    self.questionListWrapper = QuestionListWrapper(questions: questions ?? [])
                }
            } else {
                print("Error decoding question")
            }
        }
    }

   var body: some View {
       ScrollView {
                
               VStack(alignment: .leading) {
                   if (!topicList.isEmpty){
                       Text("Popular")
                           .font(.system(size: 30))
                           .fontWeight(.heavy)
                           .padding(.leading, 30)
                           .padding(.top, 20)
                           .offset(y: 20)
                   }
                   
                   
                   ScrollView(.horizontal, showsIndicators: false) {
                       HStack(spacing: 20) {
                           ForEach(topicList, id: \.self) { topic in
                               Button (action: {
                                   self.makeQuestions(topic: topic, num_questions: 3)
                               }) {
                                   CertificateView(color:"background4", item: topic)
                               }.sheet(item: $questionListWrapper) { wrapper in
                                   QuestionsView(info: Info(title: topic, peopleAttended: 100, rules: ["Answer the questions carefully"]), questions: wrapper.questions) {
                                       // some action
                                   }
                               }
                               
                           }
                       }
                       .padding(20)
                       .padding(.leading, 10)
                   }
               }
               .onAppear {
                   self.getTopics()
               }
               //.sheet(isPresented: $loading) { LoadingView() }
               
               VStack(alignment: .leading) {
                   if (!topicList.isEmpty){
                       Text("Computer Science")
                           .font(.system(size: 30))
                           .fontWeight(.heavy)
                           .padding(.leading, 30)
                           .offset(y: 20)
                   }
                   
                   
                   ScrollView(.horizontal, showsIndicators: false) {
                       HStack(spacing: 20) {
                           ForEach(topicList, id: \.self) { topic in
                               Button (action: {
                                   self.makeQuestions(topic: topic, num_questions: 3)
                               }) {
                                   CertificateView(color:"background3", item: topic)
                               }.sheet(item: $questionListWrapper) { wrapper in
                                   QuestionsView(info: Info(title: topic, peopleAttended: 100, rules: ["Answer the questions carefully"]), questions: wrapper.questions) {
                                       // some action
                                   }
                               }
                               
                           }
                       }
                       .padding(20)
                       .padding(.leading, 10)
                   }
               }
               
               .sheet(isPresented: $loading) { LoadingView() }
               .sheet(isPresented: $pageLoad) { LoadingView() }
          
       }.onAppear {
           self.getTopics()
       }
           
      
   }
}

#if DEBUG
struct CertificateRow_Previews: PreviewProvider {
   static var previews: some View {
      CertificateRow()
   }
}
#endif

struct Certificate: Identifiable {
   var id = UUID()
   var title: String
   var image: String
   var width: Int
   var height: Int
}

let certificateData = [
   Certificate(title: "Math", image: "10799", width: 230, height: 150),
   Certificate(title: "History", image: "history", width: 230, height: 150),
   Certificate(title: "Science", image: "science", width: 230, height: 150),
   Certificate(title: "English", image: "", width: 230, height: 150)
]
