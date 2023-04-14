//
//  LoadingView.swift
//  trivai
//
//  Created by Mason Bulling on 4/2/23.
//  Copyright © 2023 Mithun. All rights reserved.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray, lineWidth: 8)
                .frame(width: 100, height: 100)
            
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(Color("background3"), lineWidth: 8)
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
        }
        .onAppear {
            self.isAnimating = true
        }
    }
}


struct LoadingView_Preview: View {
    var body: some View {
        VStack {
            LoadingView()
        }
    }
}
