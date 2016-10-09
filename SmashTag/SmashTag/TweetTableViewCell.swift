//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by lyxia on 2016/9/27.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var tweeterLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private var curUrl: URL?
    private func updateUI() {
        //reset any exsiting tweet info
        profileImageView?.image = nil
        createdTimeLabel?.text = nil
        tweeterLabel?.text = nil
        tweetTextLabel?.text = nil
        
        //load new infomation from our tweet (if any)
        if let tweet = self.tweet {
            curUrl = tweet.user.profileImageURL
            
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += "📷"
                }
            }
            
            tweeterLabel?.text = "\(tweet.user)"
            
            if let profileImageURL = tweet.user.profileImageURL {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: profileImageURL) {
                        DispatchQueue.main.async { [weak weakSelf = self] in
                            if profileImageURL == weakSelf?.curUrl {
                                weakSelf?.profileImageView?.image = UIImage(data: imageData)
                            }
                        }
                    }
                }
            }
            
            let formatter = DateFormatter()
            if Date().timeIntervalSince(tweet.created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            createdTimeLabel?.text = formatter.string(from: tweet.created)
        }
    }
}
