//
//  CustomButton.swift
//  TrivAI
//
//  Created by Mason Bulling on 04/02/2023.
//

import SwiftUI

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
                .cornerRadius(10.0)
        }
        /// - Removing Padding
        //.padding([.bottom,.horizontal],-15)
    }
}
