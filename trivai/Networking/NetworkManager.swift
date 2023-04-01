//
//  NetworkManager.swift
//  trivai
//
//  Created by Ken Chiem on 3/13/23.
//  Copyright © 2023 Mithun. All rights reserved.
//

import Alamofire
import SwiftUI

class NetworkManager {
    
    static let host = "http://100.26.175.163:5000"
    static let local_host = "http://192.168.4.43:3000"
    
    // Testing
    static func testQuestions(completion: @escaping ([Question]?, Bool, _ errorMsg: String?) -> Void) {
        let endpoint = "\(host)/questions"
    
        AF.request(endpoint).validate().responseData {
            response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let userResponse = try? jsonDecoder.decode([Question].self, from: data) {
                    completion(userResponse, true, nil)
                } else {
                    print("Failed to decode question")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    // Create multiple choice questions
    static func createQuestions(user_input: String, completion: @escaping ([Question]?, Bool, _ errorMsg: String?) -> Void) {
        let endpoint = "\(host)/mcq/topic"
    
        let params : Parameters = [
            "user_input": user_input
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let userResponse = try? jsonDecoder.decode([Question].self, from: data) {
                    completion(userResponse, true, nil)
                } else {
                    print("Failed to decode question")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Create multiple choice questions based on topic
    static func createTopicQuestion(topic: String, num_questions: Int, completion: @escaping ([Question]?, Bool, _ errorMsg: String?) -> Void) {
        let endpoint = "\(local_host)/mcq/topic/"
        
        let params : Parameters = [
            "topic": topic,
            "num_questions": num_questions
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let userRespone = try? jsonDecoder.decode([Question].self, from: data) {
                    completion(userRespone, true, nil)
                } else {
                    print("Failed to decode topic questions")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Create true/false question
    static func createTFQuestion(user_input: String, completion: @escaping ([Question]?, Bool, _ errorMsg: String?) -> Void) {
        let endpoint = "\(host)/tf/"
        
        let params : Parameters = [
            "user_input": user_input
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let userResponse = try? jsonDecoder.decode([Question].self, from: data) {
                    completion(userResponse, true, nil)
                } else {
                    print("Failed to decode true false questions")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Get topics
    static func getTopics(completion: @escaping ([Question]?, Bool, _ errorMsg: String?) -> Void) {
        let endpoint = "\(host)/topics/"
        
        
        AF.request(endpoint, method: .post, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let userResponse = try? jsonDecoder.decode([Question].self, from: data) {
                    completion(userResponse, true, nil)
                } else {
                    print("Failed to decode true false questions")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Registers a user
    static func register(username: String, password: String, user_type: String, completion: @escaping (User, Bool, _ errorMsh: String?) -> Void) {
        let endpoint = "\(host)/register/"
        
        let params : Parameters = [
            "username": username,
            "password": password,
            "user_type": user_type
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let userResponse = try? jsonDecoder.decode(User.self, from: data) {
                    completion(userResponse, true, nil)
                } else {
                    print("Failed to decode user")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
