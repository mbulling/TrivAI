//
//  ScanData.swift
//  trivai
//
//  Created by Iram Liu on 3/19/23.
//  Copyright © 2023 Mithun. All rights reserved.
//
import Foundation

struct ScanData:Identifiable{
    var id = UUID()
    let content:String
    
    init(content:String) {
        self.content = content
        print(self.content)
    }
}
