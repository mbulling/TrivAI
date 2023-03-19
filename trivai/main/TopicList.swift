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
                    .font(.system(size: 30))
                    .fontWeight(.heavy)
                    .padding(.leading, 30)
                    .offset(y: 20)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                ForEach(topicList, id: \.self) { topic in
                    Text(topic)
                }
            }
            .padding(20)
            .padding(.leading, 10)
        }
        .onAppear {
            self.getTopics()
        }
    }
}

