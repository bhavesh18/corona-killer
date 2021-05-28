//
//  SessionManager.swift
//  FoodHub
//
//  Created by Bhavesh Sharma on 14/03/21.
//

import Foundation

class SessionManager{

    let LOCAL_DATA = "LOCAL_DATA"
    
    static let i = SessionManager()
    var localData = LocalData()

    init() {
        if let data = UserDefaults.standard.string(forKey: LOCAL_DATA){
            if let ld = data.getObject(ofType: LocalData()){
                self.localData = ld
            }
        }
    }

    func save(){
        if let data = self.localData.getJsonString(){
            UserDefaults.standard.setValue(data, forKey: LOCAL_DATA)
        }
    }

    func getCurrentUserIndex(of username: String)->Int?{
        return localData.users.firstIndex(where: {$0.username == username})
    }

}
