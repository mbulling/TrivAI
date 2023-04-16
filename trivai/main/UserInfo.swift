//
//  UserInfo.swift
//  trivai
//
//  Created by Mason Bulling on 4/2/23.
//  Copyright © 2023 Mithun. All rights reserved.
//

import Foundation
import SwiftUI

struct UserInfo: View {
    @State private var wins = 0
    @State private var games = 0
    
    func updateScores() {
        self.wins = LocalStorage.myWinsV
        self.games = LocalStorage.myGamesV
    }
    
    var body: some View {
        VStack {
            Text(LocalStorage.myValue)
                .textCase(.uppercase)
                .fontWeight(.heavy)
                .font(.system(size: 60))
                .padding()
                .foregroundColor(Color("background3"))

            
            HStack {
                Spacer()
                
                VStack {
                    Text("YOUR\nWINS")
                        .foregroundColor(Color("background3"))
                        .fontWeight(.medium)
                        .font(.system(size: 24))
                    
                    Text(String(self.wins))
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                }.padding()
                
                Spacer()
                
                VStack {
                    Text("GAMES\nPLAYED")
                        .foregroundColor(Color("background3"))
                        .fontWeight(.medium)
                        .font(.system(size: 24))
                    Text(String(self.games))
                        .font(.system(size: 20))
                        .fontWeight(.medium)

                }.padding()
                
                Spacer()
            }
            
            VStack {
                Text("ACCURACY")
                    .foregroundColor(.gray)
                    .fontWeight(.heavy)
                    .font(.system(size: 18))
                Text("\((Float(self.wins * 100)/Float(self.games)), specifier: "%.2f")%")
                    .font(.system(size: 35))
                    .foregroundColor(Color("background4"))
            }
            
            
        }.onAppear(perform: { self.updateScores() })
    }
}

#if DEBUG
struct UserInfo_Previews: PreviewProvider {
   static var previews: some View {
      UserInfo()
//         .environment(\.colorScheme, .dark)
   }
}
#endif
