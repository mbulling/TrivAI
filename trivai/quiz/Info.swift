//
//  Info.swift
//  TrivAI
//
//  Created by Ryan Ho on 02/24/2023.
//

import SwiftUI

// MARK: Quiz Info Codable Model
struct Info: Codable{
    var title: String
    var peopleAttended: Int
    var rules: [String]
    
    enum CodingKeys: CodingKey {
        case title
        case peopleAttended
        case rules
    }
}
