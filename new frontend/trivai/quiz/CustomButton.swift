//
//  CustomButton.swift
//  TrivAI
//
//  Created by Ryan Ho on 02/24/2023.
//

import SwiftUI

// MARK: Reusable Custom Button (Ignores Safe Area)
struct CustomButton: View{
    var title: String
    var onClick: ()->()
    
    var body: some View{
        Button {
            onClick()
        } label: {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .hAlign(.center)
                .padding(.top,15)
                .padding(.bottom,15)
                .foregroundColor(.white)
                .background {
                    Rectangle()
                        .fill(Color("Pink"))
                        .ignoresSafeArea()
                }
        }
        /// - Removing Padding
        //.padding([.bottom,.horizontal],-15)
    }
}
