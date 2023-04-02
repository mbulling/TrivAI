//
//  TabBar.swift
//  TrivAI
//
//  Created by Ryan Ho on 03/04/23.
//

import SwiftUI

struct TabBar: View {
   var body: some View {
      TabView {
         Home().tabItem {
            Image("IconHome")
            Text("Home")
         }
         .tag(1)
         CertificateRow().tabItem {
            Image("IconCards")
            Text("Explore")
         }
         .tag(2)
//         Settings().tabItem {
//            Image("IconSettings")
//            Text("Settings")
//         }
//         .tag(3)
      }
      .edgesIgnoringSafeArea(.top)
   }
}

#if DEBUG
struct TabBar_Previews: PreviewProvider {
   static var previews: some View {
      TabBar()
//         .environment(\.colorScheme, .dark)
   }
}
#endif
