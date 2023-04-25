//
//  HomeList.swift
//  TrivAI
//
//  Created by Mason Bulling on 03/04/23.
//
import SwiftUI

struct HomeList: View {

   var courses = coursesData
    var name = ""
   @State var showContent = false
    @State var topicContent = false
    @State var showNetworkTesting = false
    @State var showScanner = false
    @State var showLoad = false
    @State var scannedPassage = ""
    @State var showCVQuiz = false
    
   

    var body: some View {
            ScrollView {
                VStack {
                    Text("Welcome,")
                        .fontWeight(.heavy)
                        .padding(.top, 30)
                        .foregroundColor(Color("background3"))
                        .hAlign(.leading)
                        .padding(.leading, 30)
                        .font(.system(size: 60))
                        .scaledToFill()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if (self.name != "") {
                        Text("\(self.name).")
                            .fontWeight(.heavy)
                            .foregroundColor(Color("background4"))
                            .hAlign(.leading)
                            .padding(.leading, 30)
                            .padding(.bottom, 40)
                            .font(.system(size: 50))
                            .scaledToFill()
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 30.0) {
                                ForEach(courses) { item in
                                    Button(action: {
                                        if (item.title == "Your Quizzes") {
                                            self.topicContent.toggle()
                                        } else if (item.title == "Create a Quiz") {
                                            self.showNetworkTesting.toggle()
                                        } else {
                                            self.showScanner.toggle()
                                        }
                                    }) {
                                        GeometryReader { geometry in
                                            CourseView(title: item.title,
                                                       image: item.image,
                                                       color: item.color,
                                                       shadowColor: item.shadowColor)
                                            .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
                                        }
                                        .frame(width: 246, height: 400)
                                        .sheet(isPresented: $topicContent) {
                                            TopicList()
                                        }
                                        .sheet(isPresented: $showNetworkTesting) {
                                            NetworkTesting()
                                        }
                                        .sheet(isPresented: self.$showScanner, content: {
                                            ScannerView(completion: {
                                                textPerPage in if let outputText = textPerPage?.joined(separator: "\n"){
                                                    self.scannedPassage += outputText.split(separator: "\n").joined(separator: " ")
                                                    print(self.scannedPassage)
                                                }
                                                self.showScanner = false
                                                self.showCVQuiz = true
                                            })
                                        }).sheet(isPresented: self.$showCVQuiz, content: {
                                            //Change the user_input to scannedPassage once we get the endpoint.
                                            CVNetworking(user_input: "Apples")
                                        })
                                    }
                                }
                            }
                            
                            .padding(.leading, 30)
                            .padding(.bottom, 60)
                            Spacer()
                        }
                    }.offset(y: -15)
                    
                }
                .padding(.top, 55)
                
//                VStack {
//                    CertificateRow()
//                }.offset(y: -50)
                
                
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
      return VStack(alignment: .center) {
         Text(title)
              .font(.system(size: 30))
              
            .fontWeight(.medium)
            .textCase(.uppercase)
            .foregroundColor(.white)
            .padding(30)
            .lineLimit(4)

         Spacer()

         Image(image)
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fit)
            .frame(width: 176, height: 200)
            .padding(.bottom, 50)
            .cornerRadius(10)

      }
        
      .background(color)
      .cornerRadius(40)
      .frame(width: 306, height: 355)
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

   Course(title: "Create a Quiz",
          image: "myQuiz",
          color: Color("background3"),
          shadowColor: Color("backgroundShadow3")),
 Course(title: "Scan page",
image: "myCamera",
color: Color("background7"),
shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
   //Course(title: "Your Quizzes",
    // image: "newQuiz",
    //color: Color("background4"),
     //shadowColor: Color("backgroundShadow4")),
]
