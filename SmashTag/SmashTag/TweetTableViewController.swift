//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by lyxia on 2016/9/26.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    var appDelegate: AppDelegate? { return UIApplication.shared.delegate as? AppDelegate }
    var managedObjectContext: NSManagedObjectContext? {return appDelegate?.persistentContainer.viewContext}
    
    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
    } 
    
    private var twitterRequest: Request? {
        if let query = searchText , !query.isEmpty {
            return Request(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: Request?
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets({ [weak weakSelf = self] (newTweets) in
                DispatchQueue.main.async {
                    if request == weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, at: 0)
                            weakSelf?.updateDatabase(newTweets: newTweets)
                        }
                    }
                    weakSelf?.refreshControl?.endRefreshing()
                }
            })
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func updateDatabase(newTweets: [Twitter.Tweet]) {
        managedObjectContext?.perform {
            for twitterInfo in newTweets {
                _ = Tweet.tweetWithTwitterInfo(twitterInfo: twitterInfo, inManagedObjectContext: self.managedObjectContext!)
            }
            self.appDelegate?.saveContext()
        }
        printDatabaseStatistics()
        print("done printing database statistics")
    }
    
    private func printDatabaseStatistics() {
        managedObjectContext?.perform {
            if let results = try? self.managedObjectContext!.fetch(NSFetchRequest(entityName: "TwitterUser")) {
                print("\(results.count) TwitterUser")
            }
            // a more efficient way to count objects ...
            let tweetCount = try? self.managedObjectContext!.count(for: NSFetchRequest<Tweet>(entityName: "Tweet"))
            print("\(tweetCount) Tweets")
        }
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }

        return cell
    }
    
    // MARK: - Search
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        self.refreshControl?.beginRefreshing()
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TweetersMentioningSearchTerm" {
            if let tweetersTVC = segue.destination as? TweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.managedObjectContext = managedObjectContext
            }
        }
    }
}
