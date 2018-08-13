//
//  Item.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-08-09.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class Item: NSObject {
    var ID: Int = 0
    var DESCRIPTION: String = ""
    var I_NAME: String = ""
    var R_ID: Int = 0
    var PRICE: Int = 0
    var STATUS: String = "NA"
    var Restaurent: Restaurent? = nil
}
