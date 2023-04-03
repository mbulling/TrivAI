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
            Image(systemName: "house.circle")
            Text("Home")
         }
         .tag(1)
         CertificateRow().tabItem {
            Image(systemName: "brain.head.profile")
            Text("Explore")
         }
         .tag(2)
         NotConnectedView().tabItem {
            Image(systemName: "brain.head.profile")
            Text("Multiplayer")
         }
         .tag(3)
         UserInfo().tabItem {
            Image(systemName: "person.circle")
            Text("Profile")
         }
         .tag(4)
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
