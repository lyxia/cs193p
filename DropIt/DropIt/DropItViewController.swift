//
//  DropItViewController.swift
//  DropIt
//
//  Created by lyxia on 2016/10/8.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController {

    @IBOutlet weak var gameView: DropItView! {
        didSet {
            gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHandler(gesture:))))
            gameView.addGestureRecognizer(UIPanGestureRecognizer(target: gameView, action: #selector(DropItView.grabDrop(recognizer:))))
            gameView.realGravity = true
        }
    }
    
    func tapHandler(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            gameView.createDrop(position: gesture.location(in: gameView))
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.animating = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameView.animating = false
    }
    
}
