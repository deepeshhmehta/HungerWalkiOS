//
//  BasicData+CoreDataProperties.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-07-26.
//  Copyright © 2018 DGames. All rights reserved.
//
//

import Foundation
import CoreData

extension BasicData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BasicData> {
        return NSFetchRequest<BasicData>(entityName: "BasicData")
    }

    @NSManaged  public var tutorialComplete: Bool
    @NSManaged  public var username: String
    @NSManaged  public var userID: Int
    @NSManaged  public var logInSuccess: Bool

}

