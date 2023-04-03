//
//  LobbyView.swift
//  trivai
//
//  Created by Mason Bulling on 4/2/23.
//  Copyright © 2023 Mithun. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class WebSocket: ObservableObject {
    private let url: URL
    private var webSocketTask: URLSessionWebSocketTask?
    private var cancellable: AnyCancellable?
    
    @Published var outputLog: String = ""
    @Published var messages: [String] = []
    
    init(url: URL) {
        self.url = url
        connect()
    }
    
    private func connect() {
        let session = URLSession.shared
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                self?.output("onerror: \(error.localizedDescription)")
            case .success(let message):
                print(message)
                switch message {
                case .string(let text):
                    self?.messages.append(text)
                case .data(_):
                    self?.output("onmessage: Received binary data")
                @unknown default:
                    break
                }
                self?.receiveMessage()
            }
        }
    }
    
    func sendMessage(_ message: String) {
        guard let data = message.data(using: .utf8) else { return }
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            } else {
                print("Message sent: \(message)")
            }
        }
        self.receiveMessage()
    }
    
    func close() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    private func output(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.outputLog = "\(message)\n\(self?.outputLog ?? "")"
        }
    }
}

struct LobbyView: View {
    var roomID = -1
    @ObservedObject var webSocket = WebSocket(url: URL(string: "ws://localhost:9001/")!)
    @State var message: String = ""
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("WebSocket Output for \(roomID)")
                .font(.title2)
            ScrollView {
                Text(webSocket.outputLog)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            
            List(webSocket.messages, id: \.self) { message in
                if ((message.prefix(6)) == String(roomID)) {
                    Text(message)
                }
                
            }
                
            TextField("Enter a message", text: $message)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            Button("Send") {
                webSocket.sendMessage("\(roomID):\(message)")
                message = ""
            }
            Button("Close") {
                webSocket.close()
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct GameView: View {
    var roomID: Int
    var quizInfo: Info
    var questions: [Question]
    
    
    
    var body: some View {
        QuestionsView(info: quizInfo, questions: questions) {
            // on finish
        }
    }
}

struct WaitingForOthers: View {
    var roomID = -1
    var topic = ""
    @State var doneWaiting = false
    @State private var questionListWrapper: QuestionListWrapper? = nil
    @State var apiCall = true
    @State private var quizInfo: Info = Info(title: "Testing", peopleAttended: 100, rules: ["Answer the questions carefully"])
    
    func call_api() {
        self.quizInfo.title = self.topic
        NetworkManager.createTopicQuestion(topic: self.topic, num_questions: 5) { questions, success, error in
            self.apiCall = false
            if (success) {
                DispatchQueue.main.async {
                    self.questionListWrapper = QuestionListWrapper(questions: questions ?? [])
                    self.doneWaiting = true
                }
            } else {
                print("Error decoding question")
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Waiting for others to join")
            Text("Shared roomID with friends \(roomID)")
            
            VStack {
                Button (action: { self.doneWaiting = true }) {
                    Text("I shared the code with my friends")
                }
            }
            }
        .sheet(item: $questionListWrapper) {wrapper in  GameView(roomID: self.roomID, quizInfo: self.quizInfo, questions: wrapper.questions ) }
            .sheet(isPresented: $apiCall) { LoadingView () }
            .onAppear(perform: {self.call_api()})
            
        
    }
}

struct NotConnectedView: View {
    @State var inRoom = false
    @State var waiting = true
    @State var roomToJoin = "-1"
    @State var joinedRoom = false
    @State var topic = "Chemistry"
    
    var body: some View {
        VStack {
            TextField("Topic", text: $topic)
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
            Button (action: { self.inRoom = true }) {
                Text("Create Room")
            }
            
            TextField("Room to Join", text: $roomToJoin)
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
            Button (action: { self.joinedRoom = true }) {
                Text("Join Room")
            }.sheet(isPresented: $joinedRoom) { LobbyView(roomID: Int(self.roomToJoin) ?? -1) }
        }.sheet(isPresented: $inRoom) { WaitingForOthers(roomID: Int.random(in: 100_000...999_999), topic: self.topic) }
        
    }
}



