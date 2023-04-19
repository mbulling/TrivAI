//
//  LoadingView.swift
//  
//
//  Created by Mason Bulling on 4/14/23.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                Circle()
                    .trim(from: 0.2, to: 1.0)
                    .stroke(
                        AngularGradient(gradient: Gradient(colors: [Color.purple, Color.pink]), center: .center),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                    .onAppear {
                        isAnimating = true
                    }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}