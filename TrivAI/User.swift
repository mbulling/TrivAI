//
//  User.swift
//  TrivAI
//
//  Created by Lisa Li on 2/23/23.
//

import Foundation

enum UserType {
    case student, teacher, other
}

struct User {
    let id = UUID()
    var username:String
    var password:String
    var userType:UserType
    var score:Int
}

struct ExampleUser {
    static let demoUsers = [User(username: "bob", password: "bob_is_cool", userType:student, score: 0), User(username: "jill", password: "jill_is_cool", userType:teacher, score: 1)]
}
