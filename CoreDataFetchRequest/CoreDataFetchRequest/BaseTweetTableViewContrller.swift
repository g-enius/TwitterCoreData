//
//  BaseTweetTableViewContrller.swift
//  CoreDataFetchRequest
//
//  Created by Charles on 12/05/17.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import Twitter

class BaseTweetTableViewContrller: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextFiled: UITextField! {
        didSet{
            searchTextFiled.delegate = self
        }
    }
    
    @IBAction func refresh(_ sender:UIRefreshControl) {
        searchForTweets()
    }
    
    private var tweets = [Array<Twitter.Tweet>]()
    private var lastTwitterRequest: Twitter.Request?
    
    var searchText: String? {
        didSet {
            searchTextFiled?.text = searchText
            searchTextFiled?.resignFirstResponder()
            lastTwitterRequest = nil
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func insertTweets(_ newTweets:[Twitter.Tweet]) {
        self.tweets.insert(newTweets, at:0)
        self.tableView.insertSections([0], with:.fade)
    }
    
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query, count: 100)
        }
        return nil;
    }

    func searchForTweets() {
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                if(newTweets.count > 0) {
                    DispatchQueue.main.async {
                        if request == self?.lastTwitterRequest {
                            self?.insertTweets(newTweets)
                        }
                    }
                }
                self?.refreshControl?.endRefreshing()
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextFiled {
            searchText = searchTextFiled.text
        }
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        let tweet:Twitter.Tweet = tweets[indexPath.section][indexPath.row]
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }
}

