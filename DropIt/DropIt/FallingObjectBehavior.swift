//
//  FallingObjectBehavior.swift
//  DropIt
//
//  Created by lyxia on 2016/10/8.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import UIKit

class FallingObjectBehavior: UIDynamicBehavior {

    let gravity = UIGravityBehavior()
    
    private let collision: UICollisionBehavior = {
        let collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true
        return collision
    }()
    
    private let itemBehavior: UIDynamicItemBehavior = {
        let item = UIDynamicItemBehavior()
        item.allowsRotation = true
        item.elasticity = 0.35
        return item
    }()
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collision.removeBoundary(withIdentifier: NSString(string: name))
        collision.addBoundary(withIdentifier: NSString(string: name), for: path)
    }
    
    override init() {
        super.init()
        
        self.addChildBehavior(gravity)
        self.addChildBehavior(collision)
        self.addChildBehavior(itemBehavior)
    }
    
    func addItem(_ item: UIDynamicItem) {
        gravity.addItem(item)
        collision.addItem(item)
        itemBehavior.addItem(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        gravity.removeItem(item)
        collision.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
}
