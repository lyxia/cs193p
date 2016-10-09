//
//  Tweet+CoreDataProperties.swift
//  SmashTag
//
//  Created by lyxia on 2016/9/28.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import Foundation
import CoreData

extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet");
    }

    @NSManaged public var posted: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var unique: String?
    @NSManaged public var tweeter: TwitterUser?

}
