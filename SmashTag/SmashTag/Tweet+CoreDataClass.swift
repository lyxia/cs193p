//
//  Tweet+CoreDataClass.swift
//  SmashTag
//
//  Created by lyxia on 2016/9/28.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import Foundation
import CoreData
import Twitter


public class Tweet: NSManagedObject {
    class func tweetWithTwitterInfo(twitterInfo: Twitter.Tweet, inManagedObjectContext context: NSManagedObjectContext) -> Tweet? {
        
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id)
        
        if let tweet = (try? context.fetch(request))?.first {
            return tweet
        } else if let tweet = NSEntityDescription.insertNewObject(forEntityName: "Tweet", into: context) as? Tweet {
            tweet.unique = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.posted = NSDate(timeInterval: 0, since: twitterInfo.created)
            tweet.tweeter = TwitterUser.twitterUserWithTwitterInfo(twitterInfo: twitterInfo.user, inManagedObjectContext: context)
            return tweet
        }
        
        return nil
    }
}
