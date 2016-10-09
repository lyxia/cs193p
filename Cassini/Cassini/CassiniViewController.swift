//
//  CassiniViewController.swift
//  Cassini
//
//  Created by lyxia on 2016/9/23.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contentViewController == self {
            if let ivc = secondaryViewController.contentViewController as? ImageViewController , ivc.imageUrl != nil {
                return true
            }
        }
        return false
    }

    // MARK: - Navigation

    struct StoryBoardInfo {
        static let SegueName:String = "Show Images"
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == StoryBoardInfo.SegueName {
                if let ivc = segue.destination.contentViewController as? ImageViewController {
                    ivc.imageUrl = ImageUrlServer.getUrlByName((sender as? UIButton)?.currentTitle ?? "")
                    ivc.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }
    
    @IBAction func showDetail(_ sender: UIButton) {
        if let ivc = splitViewController?.viewControllers.last?.contentViewController as? ImageViewController {
            ivc.imageUrl = ImageUrlServer.getUrlByName(sender.currentTitle ?? "")
            ivc.title = sender.currentTitle
        } else {
            performSegue(withIdentifier: StoryBoardInfo.SegueName, sender: sender)
        }
    }

}

extension UIViewController {
    var contentViewController: UIViewController {
        if let nav = self as? UINavigationController {
            return nav.visibleViewController ?? self
        }
        return self
    }
}
