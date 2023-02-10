//
//  TrivAIApp.swift
//  TrivAI
//
//  Created by Mason Bulling on 2/6/23.
//

import SwiftUI
import AWSCore
import AWSLambda

@main
struct TrivAIApp: App {
    init() {
        initializeLambda()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

func initializeLambda() {
        let credentialsProvider = AWSStaticCredentialsProvider.init(accessKey:Constants.AWS_ACCESS_KEY, secretKey: Constants.AWS_SECRET_KEY)
        let defaultServiceConfiguration = AWSServiceConfiguration(region: Constants.AWS_REGION, credentialsProvider: credentialsProvider)
    AWSServiceManager.default().defaultServiceConfiguration = defaultServiceConfiguration
    }
