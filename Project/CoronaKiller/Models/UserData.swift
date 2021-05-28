//
//  UserData.swift
//  CoronaKiller
//
//  Created by Bhavesh Sharma on 22/05/21.
//

import Foundation

class UserData: Codable{

    var username: String!
    var email: String!
    var password: String!
    var score: Int! = 0
    
    init(username: String, email: String, password: String, score: Int) {
        self.username = username
        self.email = email
        self.password = password
        self.score = score
    }
    
}
