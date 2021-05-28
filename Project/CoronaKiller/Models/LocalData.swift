//
//  LocalData.swift
//  CoronaKiller
//
//  Created by Bhavesh Sharma on 22/05/21.
//

import Foundation

class LocalData: Codable{
    var users: [UserData] = []
    var currentUserIndex: Int?
    var isLoggedIn = false
    
    init() {
        
    }
}
