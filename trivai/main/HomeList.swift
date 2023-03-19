//
//  HomeList.swift
//  TrivAI
//
//  Created by Mason Bulling on 03/04/23.
//

import SwiftUI

struct HomeList: View {
    var courses = coursesData
    @State private var topicContent = false
    @State private var showContent = false
    @State private var showScanner = false
    @State private var texts: [ScanData] = []
    
    var body: some View {
        ScrollView {
            VStack {
                Text("TrivAI")
                    .fontWeight(.heavy)
                    .font(.system(size: 55))
                    .padding(.leading, 30)
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 30.0) {
                            ForEach(courses) { item in
                                if (item.title == "Your Quizzes") {
                                    Button(action: { self.topicContent.toggle() }) {
                                        GeometryReader { geometry in
                                            CourseView(title: item.title,
                                                       image: item.image,
                                                       color: item.color,
                                                       shadowColor: item.shadowColor)
                                            .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
                                        }
                                        .frame(width: 246, height: 360)
                                        .sheet(isPresented: self.$topicContent) {
                                            TopicList()
                                        }
                                    }
                                }
                                else{
                                    Button(action: { self.showContent.toggle() }) {
                                        GeometryReader { geometry in
                                            CourseView(title: item.title,
                                                       image: item.image,
                                                       color: item.color,
                                                       shadowColor: item.shadowColor)
                                            .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
                                        }
                                        .frame(width: 246, height: 360)
                                        .sheet(isPresented: self.$showContent) {
                                            Load()
                                        }
                                    }
                                }
                            }
                            Button(action:{ self.showScanner = true}){
                                GeometryReader { geometry in
                                    CourseView(title: "Scan Page",
                                               image: "Illustration3",
                                               color: Color("background7"),
                                               shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5))
                                    .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
                                }
                                .frame(width: 246, height: 360)
                                .sheet(isPresented: self.$showScanner, content: {
                                    ScannerView(completion: { textPerPage in
                                        if let outputText = textPerPage?.joined(separator: "\n") {
                                            let newScanData = ScanData(content: outputText)
                                            // We need to pass this data into the question generation model somehow
                                            self.texts.append(newScanData)
                                            print(newScanData)
                                        }
                                        self.showScanner = false
                                    })
                                })
                            }
                        }
                        .padding(.leading, 30)
                        .padding(.bottom, 60)
                        Spacer()
                    }
                }
                .offset(y: -15)
            }
            .padding(.top, 70)
            VStack {
                CertificateRow()
            }.offset(y: -50)
            VStack{
                if texts.count > 0{
                    List{
                        ForEach(texts){
                            text in NavigationLink(
                                destination:ScrollView{Text(text.content)},
                                label: {
                                    Text(text.content).lineLimit(1)
                                })
                        }
                    }
                }else{
                    Text("No Scan Yet")
                }
            }
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
]
/*
import SwiftUI

struct HomeList: View {

   var courses = coursesData
   @State var showContent = false
   @State var topicContent = false
    @State var showScanner = false
   @State var texts:[ScanData] = []
   var body: some View {
      ScrollView {
          VStack {
              Text("TrivAI")
                  .fontWeight(.heavy)
                  .font(.system(size: 55))
                  .hAlign(.leading)
                  .padding(.leading, 30)
                  .padding(.top, 70)
              VStack {
                  ScrollView(.horizontal, showsIndicators: false) {
                      HStack(spacing: 30.0) {
                          ForEach(courses) { item in
                              if (item.title == "Your Quizzes") {
                                  Button(action: { self.topicContent.toggle() }) {
                                      GeometryReader { geometry in
                                          CourseView(title: item.title,
                                                     image: item.image,
                                                     color: item.color,
                                                     shadowColor: item.shadowColor)
                                          .rotation3DEffect(Angle(degrees:
                                                                    Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
                                          .sheet(isPresented: self.$topicContent) {
                                              TopicList()
                                          }
                                      }
                                      .frame(width: 246, height: 360)
                                  }
                              } else if (item.title == "Scan Page"){
                                  Button(action: { self.showScanner = true}){
                                      GeometryReader { geometry in
                                          CourseView(title: item.title,
                                                     image: item.image,
                                                     color: item.color,
                                                     shadowColor: item.shadowColor)
                                          .rotation3DEffect(Angle(degrees:
                                                                    Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
                                      }
                                      .frame(width: 246, height: 360)
                                  }.sheet(isPresented: self.$showScanner, content: {
                                      ScannerView(completion: {
                                          textPerPage in if let outputText = textPerPage?.joined(separator: "\n"){
                                              let newScanData = ScanData(content: outputText)
                                              //We need to pass this data into the question generation model somehow
                                              print(newScanData)
                                              self.texts.append(newScanData)
                                          }
                                          self.showScanner = false
                                      })
                                  })
                              }
                              else{
                                      Button(action: { self.showContent.toggle() }) {
                                          GeometryReader { geometry in
                                              CourseView(title: item.title,
                                                         image: item.image,
                                                         color: item.color,
                                                         shadowColor: item.shadowColor)
                                              .rotation3DEffect(Angle(degrees:
                                                                        Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
                                              .sheet(isPresented: self.$showContent) {
                                                  Load()
                                              }
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
              
              VStack {
                  CertificateRow()
              }.offset(y: -50)
          }
              VStack{
                  if texts.count > 0{
                      List{
                          ForEach(texts){
                              text in NavigationLink(
                                destination:ScrollView{Text(text.content)},
                                label: {
                                    Text(text.content).lineLimit(1)
                                })
                          }
                      }
                  }else{
                      Text("No Scan Yet")
                  }
              }
          

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
   Course(title: "Scan Page",
          image: "Illustration3",
          color: Color("background7"),
          shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
]
*/
