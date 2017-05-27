//
//  Tweet.swift
//  CoreDataFetchRequest
//
//  Created by Charles on 14/05/17.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import CoreData
import Twitter

//Core Data generate getter/setter by extension

class Tweet: NSManagedObject {
    class func findOrCreateTweet(matching twitterInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> Tweet
    {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Tweet.findOrCreateTweet -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let tweet = Tweet(context: context) // create an instance in dabase equals to NSEntityDescription.insertNewObject(forEntityName:"Tweet", into:context)
        tweet.unique = twitterInfo.identifier
        tweet.text = twitterInfo.text
        tweet.created = twitterInfo.created as NSDate
        tweet.tweeter = try? TwitterUser.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)
        return tweet
    }

}
