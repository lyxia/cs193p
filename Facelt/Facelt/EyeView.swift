//
//  EyeView.swift
//  Facelt
//
//  Created by lyxia on 2016/10/6.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import UIKit

class EyeView: UIView {

    var lineWidth: CGFloat = 5.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var color: UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var _eyeOpen: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var eyeOpen: Bool {
        get {
            return _eyeOpen
        }
        set {
            UIView.transition(
                with: self,
                duration: 0.2,
                options: [.transitionFlipFromTop, .curveLinear],
                animations: { 
                    self._eyeOpen = newValue
                },
                completion: nil
            )
        }
    }
    
    override func draw(_ rect: CGRect) {
        var path: UIBezierPath!
        
        if eyeOpen {
            path = UIBezierPath(ovalIn: bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2))
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        }
        
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }

}
