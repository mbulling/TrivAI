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
                .font(.system(size: 50))
                .padding()
            
            HStack {
                Spacer()
                
                VStack {
                    Text("WINS")
                        .foregroundColor(.gray)
                    Text(String(self.wins))
                        .font(.system(size: 20))
                }.padding()
                
                Spacer()
                
                VStack {
                    Text("GAMES PLAYED")
                        .foregroundColor(.gray)
                    Text(String(self.games))
                        .font(.system(size: 20))
                }.padding()
                
                Spacer()
            }
            
            VStack {
                Text("ACCURACY")
                    .foregroundColor(.gray)
                    .fontWeight(.heavy)
                    .font(.system(size: 18))
                Text("\((Float(self.wins * 100)/Float(self.games)), specifier: "%.2f")%")
                    .font(.system(size: 25))
            }
            
            
        }.onAppear(perform: { self.updateScores() })
    }
}


struct UserInfo_Preview: View {
    var body: some View {
        VStack {
            UserInfo()
        }
    }
}
