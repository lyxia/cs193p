//
//  UIKit Extensions.swift
//  DropIt
//
//  Created by lyxia on 2016/10/8.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    var lowerLeft: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }
    
    var mid: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
    init(center: CGPoint, size: CGSize) {
        let upperLeft = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.init(origin: upperLeft, size: size)
    }
}

extension UIColor {
    class var random: UIColor {
        switch arc4random() % 5 {
        case 0:
            return UIColor.blue
        case 1:
            return UIColor.red
        case 2:
            return UIColor.brown
        case 3:
            return UIColor.purple
        case 4:
            return UIColor.orange
        default:
            return UIColor.black
        }
    }
}
