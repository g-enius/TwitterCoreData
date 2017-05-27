//
//  TweetTableViewCell.swift
//  CoreDataFetchRequest
//
//  Created by Charles on 13/05/17.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

//    @IBOutlet weak var tweetTextLabel: UILabel!
    
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    
    private func updateUI() {
        tweetTextLabel?.text = tweet?.text
        tweetUserLabel?.text = tweet?.user.description
        
        if let profileImageURL = tweet?.user.profileImageURL {
            tweetProfileImageView.image = nil
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: profileImageURL) {
                    DispatchQueue.main.async { [weak self] in
                        if (profileImageURL == self?.tweet?.user.profileImageURL) {
                            self?.tweetProfileImageView?.image = UIImage(data: imageData)
                        }
                    }
                    
                }
            }
            
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }

}
