//
//  TweetersTableViewController.swift
//  SmashTag
//
//  Created by lyxia on 2016/9/28.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import CoreData
import UIKit

class TweetersTableViewController: CoreDataTableViewController {
    
    var mention: String? {
        didSet {
            updateUI()
        }
    }
    var managedObjectContext: NSManagedObjectContext? {
        didSet {
            print(TweetersTableViewController())
            updateUI()
        }
    }
    
    private func updateUI() {
        if let context = managedObjectContext , (mention != nil) ,mention!.characters.count > 0 {
            let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@", mention!)
            request.sortDescriptors = [NSSortDescriptor(
                key:"screenName",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
            fetchedResultsController = NSFetchedResultsController<TwitterUser>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            ) as? NSFetchedResultsController<NSFetchRequestResult>
        } else {
            fetchedResultsController = nil
        }
    }
    
    // MARK - Table view dataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUserCell", for: indexPath)
        
        if let twitterUser = fetchedResultsController?.object(at: indexPath) as? TwitterUser {
            var screenName: String?
            twitterUser.managedObjectContext?.performAndWait {
                screenName = twitterUser.screenName
            }
            cell.textLabel?.text = screenName
        }
        
        return cell
    }
    
}
