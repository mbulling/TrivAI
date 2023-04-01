//
//  CertificateRow.swift
//  TrivAI
//
//  Created by Ryan Ho on 03/04/23.
//

import SwiftUI

struct CertificateRow: View {

   var certificates = certificateData

   var body: some View {
      VStack(alignment: .leading) {
         Text("Popular")
            .font(.system(size: 30))
            .fontWeight(.heavy)
            .padding(.leading, 30)
            .offset(y: 20)

         ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
               ForEach(certificates) { item in
                  CertificateView(item: item)
               }
            }
            .padding(20)
            .padding(.leading, 10)
         }
      }
   }
}

#if DEBUG
struct CertificateRow_Previews: PreviewProvider {
   static var previews: some View {
      CertificateRow()
   }
}
#endif

struct Certificate: Identifiable {
   var id = UUID()
   var title: String
   var image: String
   var width: Int
   var height: Int
}

let certificateData = [
   Certificate(title: "Math", image: "10799", width: 230, height: 150),
   Certificate(title: "History", image: "history", width: 230, height: 150),
   Certificate(title: "Science", image: "science", width: 230, height: 150),
   Certificate(title: "English", image: "", width: 230, height: 150)
]
