//
//  HomeView.swift
//  TrivAI
//
//  Created by Mason Bulling on 2/6/23.
//

import Foundation
import SwiftUI
import AsyncHTTPClient

let httpClient = HTTPClient(eventLoopGroupProvider: .createNew)
let jsonDecoder = JSONDecoder()

struct HomeView: View {
    @State var show = false
    // Storing Level for Fetching Questions
    @State var set = "Round_1"
    
    // for analytics
    @State var correct = 0
    @State var wrong = 0
    @State var answerd = 0
    
    var body: some View {
        VStack {
            Text("trivAI")
                .font(.system(size: 52))
                .fontWeight(.heavy)
                .foregroundColor(.blue)
                .padding(.top)
            
            Button (action: {callLambda()}) {
                Text("Click here to test AWS")
            }
            
            Text("Select a quiz to play")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(.black)
                .padding(.top, 8)
                .multilineTextAlignment(.center)
            
            Spacer(minLength: 0)
            
            // Level View
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 35) {
                // four levels
                ForEach(1...4, id: \.self) { index in
                    VStack(spacing: 15) {
                        Image(systemName: "books.vertical")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .font(.system(size: 14, weight: .thin))
                            .frame(height: 80)
                            .padding()
                            .foregroundColor(.white)
                        
                        Text("Math Quiz")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        
                        Text("HARD")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(15)
                    // opening QA view as sheet
                    .onTapGesture {
                        set = "Round_\(index)"
                        show.toggle()
                    }
                }
            }
            .padding()
            
            Spacer(minLength: 0)
        }
        .background(Color.black.opacity(0.05).ignoresSafeArea())
//        .sheet(isPresented: $show) {
//            QA(correct: $correct, wrong: $wrong, answered: $answerd, set: set)
//        }
    }
    
    func callLambda() {
        httpClient.get(url: Constants.AWS_API_ROUTE).whenComplete {
          result in
            switch result {
            case .failure(_):
                print("FAILURE")
            case .success(let response):
                if let data = response.body, response.status == .ok {
                    let data = try? jsonDecoder.decode(String.self, from: data)
                    if let data = data {
                        print(data)
                    }
                }
            }
        }
    }
}
