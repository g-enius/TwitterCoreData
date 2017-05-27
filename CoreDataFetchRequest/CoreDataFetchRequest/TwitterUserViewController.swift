//
//  TwitterUserViewController.swift
//  CoreDataFetchRequest
//
//  Created by Charles on 14/05/17.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class TwitterUserViewController: FetchedResultTableViewController {
    
    var mention: String? {didSet{updateUI()}}
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
        didSet {
            updateUI()
        }
    }
    
    var fetchedResultController: NSFetchedResultsController<TwitterUser>?
    
    private func updateUI() {
        if let context = container?.viewContext, mention != nil {
            let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(
                key: "handle",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@", mention!)
            
            fetchedResultController = NSFetchedResultsController<TwitterUser>(
                    fetchRequest: request,
                    managedObjectContext: context,
                    sectionNameKeyPath: nil,
                    cacheName: nil
            )
            
            fetchedResultController?.delegate = self
            try? fetchedResultController?.performFetch()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUser Cell", for:indexPath)
        if let twitterUser = fetchedResultController?.object(at: indexPath) {
            cell.textLabel?.text = twitterUser.handle
            let tweetCount = tweetCountWithMentionBy(twitterUser)
            cell.detailTextLabel?.text = "\(tweetCount) tweet\((tweetCount == 1) ? "" : "s")"
        }
        
        return cell
    }
    
    private func tweetCountWithMentionBy(_ twitterUser:TwitterUser) -> Int {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format:"text contains[c] %@ and tweeter = %@", mention!, twitterUser)
        return (try? twitterUser.managedObjectContext!.count(for: request)) ?? 0
    }

}
