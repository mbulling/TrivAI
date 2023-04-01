//
//  ContentView.swift
//  TrivAI
//
//  Created by Ryan Ho on 03/04/23.
//

import SwiftUI

struct ContentView: View {

   @State var show = false
   @State var viewState = CGSize.zero

   var body: some View {
      ZStack {
         BlurView(style: .systemMaterial)

         TitleView()
            .blur(radius: show ? 20 : 0)
            .animation(.default)

         CardBottomView()
            .blur(radius: show ? 20 : 0)
            .animation(.default)

         CardView()
            .background(show ? Color.red : Color("background9"))
            .cornerRadius(10)
            .shadow(radius: 20)
            .offset(x: 0, y: show ? -400 : -40)
            .scaleEffect(0.85)
            .rotationEffect(Angle(degrees: show ? 15 : 0))
            .blendMode(.hardLight)
            .animation(.easeInOut(duration: 0.6))
            .offset(x: viewState.width, y: viewState.height)

         CardView()
            .background(show ? Color("background5") : Color("background8"))
            .cornerRadius(10)
            .shadow(radius: 20)
            .offset(x: 0, y: show ? -200 : -20)
            .scaleEffect(0.9)
            .rotationEffect(Angle(degrees: show ? 10 : 0))
            .blendMode(.hardLight)
            .animation(.easeInOut(duration: 0.4))
            .offset(x: viewState.width, y: viewState.height)

         CertificateView()
            .offset(x: viewState.width, y: viewState.height)
            .scaleEffect(0.95)
            .rotationEffect(Angle(degrees: show ? 5 : 0))
            .animation(.spring())
            .onTapGesture {
               self.show.toggle()
            }
            .gesture(
               DragGesture()
                  .onChanged { value in
                     self.viewState = value.translation
                     self.show = true
                  }
                  .onEnded { _ in
                     self.viewState = CGSize.zero
                     self.show = false
                  }
            )
      }
   }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}
#endif

struct CardView: View {
   var body: some View {
      return VStack {
         Text("Card Back")
      }
      .frame(width: 340.0, height: 220.0)
   }
}

struct CertificateView: View {

    var item: String = "Math"//Certificate(title: "UI Design", image: "Certificate1", width: 340, height: 220)

   var body: some View {
      return VStack {
//         Image(item.image)
//              .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(minWidth: 0, maxWidth: 280, minHeight: 0, maxHeight: 180)
//            .offset(y: 10)
//            .overlay(
                Text(item)
              .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding()
                .offset(y: -5)//, alignment: .topLeading)
      }
      .frame(width: CGFloat(280), height: CGFloat(180))
      .background(Color("background3"))
      .cornerRadius(10)
      .shadow(radius: 10)
   }
}

struct TitleView: View {
   var body: some View {
      return VStack {
         HStack {

            Spacer()
         }
         Image("Illustration5")

         Spacer()
      }.padding()
   }
}

struct CardBottomView: View {
    var cards: [String] = []
   var body: some View {
      return VStack(spacing: 20.0) {
         Rectangle()
            .frame(width: 60, height: 6)
            .cornerRadius(3.0)
            .opacity(0.1)


         Spacer()
      }
      .frame(minWidth: 0, maxWidth: .infinity)
      .padding()
      .padding(.horizontal)
      .background(BlurView(style: .systemMaterial))
      .cornerRadius(30)
      .shadow(radius: 20)
      .offset(y: UIScreen.main.bounds.height - 215)
   }
}
