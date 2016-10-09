//
//  NamedBezierPathsView.swift
//  DropIt
//
//  Created by lyxia on 2016/10/8.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import UIKit

class NamedBezierPathsView: UIView {
    
    var beizerPaths = [String: UIBezierPath] () {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        for (_, path) in beizerPaths {
            path.stroke()
        }
    }

}
