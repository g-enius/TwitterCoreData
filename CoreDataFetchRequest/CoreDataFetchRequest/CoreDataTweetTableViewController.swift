//
//  CoreDataTweetTableViewController.swift
//  CoreDataFetchRequest
//
//  Created by Charles on 14/05/17.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class CoreDataTweetTableViewController: BaseTweetTableViewContrller {

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Twitter Users" {
            if let tweetersVC = segue.destination as? TwitterUserViewController {
                tweetersVC.mention = searchText
                tweetersVC.container = container
            }
        }
    }
    
    private func updateDatabase(with tweets:[Twitter.Tweet]) {
        print("starting database load")
        //off the main queue and context is not the viewContext
        container?.performBackgroundTask{ [weak self] context in
            for twitterInfo in tweets {
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            print("done loading database")
            self?.printDababaseStatistics()
        }
    }
    
    private func printDababaseStatistics() {
        if let context = container?.viewContext {
            context.perform { //viewContext's queue: main queue
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
                
                if let tweeterCount = try? context.count(for: TwitterUser.fetchRequest()) {
                    print("\(tweeterCount) Twitter users")
                }
            }
        }
    }
}
