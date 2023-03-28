//
//  ScoreCardView.swift
//  TrivAI
//
//  Created by Ryan Ho on 02/24/2023.
//

import SwiftUI
//import FirebaseFirestore

// MARK: Score Card View
struct ScoreCardView: View{
    var score: CGFloat
    /// - Moving to Home When This View was Dismissed
    var onDismiss: ()->()
    @Environment(\.dismiss) private var dismiss
    var body: some View{
        VStack{
            VStack(spacing: 15){
                
                VStack(spacing: 15){
                    Text("Congratulations! You scored")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    /// - Removing Floating Points
                    Text(String(format: "%.0f", score) + "%")
                        .font(.title.bold())
                        .padding(.bottom,10)
                    
                    Image("trophy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 175)
                }
                .foregroundColor(.black)
                .padding(.horizontal,15)
                .padding(.vertical,20)
                .hAlign(.center)
                .background {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(.white)
                }
            }
            .vAlign(.center)
            
            CustomButton(title: "Back to Home") {
                /// - Before Closing Updating Attendend People Count on Firestore
//                Firestore.firestore().collection("Quiz").document("Info").updateData([
//                    "peopleAttended": FieldValue.increment(1.0)
//                ])
                onDismiss()
                dismiss()
            }
        }
        .padding(15)
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
    }
}
