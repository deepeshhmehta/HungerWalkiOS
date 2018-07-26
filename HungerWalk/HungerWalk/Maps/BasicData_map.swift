//
//  BasicData_map.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-07-26.
//  Copyright © 2018 DGames. All rights reserved.
//

import Foundation
import ObjectMapper

class BasicData_map: Mappable {
    public var tutorialComplete: Bool?
    public var username: String?
    public var userID: Int?
    public var logInSuccess: Bool?
    
    required init?(tutorialComplete: Bool, username: String, userID: Int, logInSuccess: Bool) {
        self.tutorialComplete = tutorialComplete
        self.username = username
        self.userID = userID
        self.logInSuccess = logInSuccess
    }
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        tutorialComplete <- map["tutorialComplete"]
        username <- map["NAME"]
        userID <- map["ID"]
        logInSuccess <- map["SUCCESS"]
    }
    

}
