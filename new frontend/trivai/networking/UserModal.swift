//
//  UserModal.swift
//  trivai
//
//  Created by Ken Chiem on 3/13/23.
//  Copyright © 2023 Mithun. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: UUID = .init()
    var username : String
    var password : String
    var user_type : UserType
    var score : Int
}

enum UserType : String, Codable {
    case STUDENT
    case TEACHER
    case OTHER
}
