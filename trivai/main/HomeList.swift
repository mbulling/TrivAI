//
//  HomeList.swift
//  TrivAI
//
//  Created by Ryan Ho on 03/04/23.
//

import SwiftUI

struct HomeList: View {

   var courses = coursesData
   @State var showContent = false

   var body: some View {
      ScrollView {
         VStack {
             Text("TrivAI")
                .fontWeight(.heavy)
                .font(.system(size: 55))
                .hAlign(.leading)
                .padding(.leading, 30)
             VStack {
                 ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30.0) {
                       ForEach(courses) { item in
                          Button(action: { self.showContent.toggle() }) {
                             GeometryReader { geometry in
                                CourseView(title: item.title,
                                           image: item.image,
                                           color: item.color,
                                           shadowColor: item.shadowColor)
                                   .rotation3DEffect(Angle(degrees:
                                      Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
                                   .sheet(isPresented: self.$showContent) { Load() }
                             }
                             .frame(width: 246, height: 360)
                          }
                       }
                    }
                    .padding(.leading, 30)
                    .padding(.bottom, 60)
                    Spacer()
                 }
             }.offset(y: -15)
            
         }
         .padding(.top, 70)
        
          VStack {
              CertificateRow()
          }.offset(y: -50)
        

      }
   }
}

#if DEBUG
struct HomeList_Previews: PreviewProvider {
   static var previews: some View {
      HomeList()
   }
}
#endif

struct CourseView: View {

   var title = "Explore Quizzes"
   var image = "Illustration1"
   var color = Color("background3")
   var shadowColor = Color("backgroundShadow3")

   var body: some View {
      return VStack(alignment: .leading) {
         Text(title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(30)
            .lineLimit(4)

         Spacer()

         Image(image)
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fit)
            .frame(width: 246, height: 150)
            .padding(.bottom, 30)
      }
      .background(color)
      .cornerRadius(30)
      .frame(width: 246, height: 360)
      .shadow(color: shadowColor, radius: 20, x: 0, y: 20)
   }
}

struct Course: Identifiable {
   var id = UUID()
   var title: String
   var image: String
   var color: Color
   var shadowColor: Color
}

let coursesData = [
   Course(title: "Your Quizzes",
          image: "Illustration1",
          color: Color("background3"),
          shadowColor: Color("backgroundShadow3")),
   Course(title: "Create a Quiz",
          image: "Illustration2",
          color: Color("background4"),
          shadowColor: Color("backgroundShadow4")),
   Course(title: "Scan page",
          image: "Illustration3",
          color: Color("background7"),
          shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
]
