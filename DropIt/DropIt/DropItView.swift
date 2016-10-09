//
//  DropItView.swift
//  DropIt
//
//  Created by lyxia on 2016/10/8.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import UIKit
import CoreMotion

class DropItView: NamedBezierPathsView, UIDynamicAnimatorDelegate {

    private let dropPerRow = 10
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        removeCompleteDrop()
    }
    
    private let fallBehavior = FallingObjectBehavior()
    
    var animating = false {
        didSet {
            if animating {
                animator.addBehavior(fallBehavior)
                updateRealGravity()
            } else {
                animator.removeBehavior(fallBehavior)
            }
        }
    }
    
    var realGravity: Bool = false {
        didSet {
            updateRealGravity()
        }
    }
    
    private let motionManager = CMMotionManager()
    
    private func updateRealGravity() {
        if realGravity {
            if motionManager.isDeviceMotionAvailable && !motionManager.isDeviceMotionActive {
                motionManager.deviceMotionUpdateInterval = 1 / 60
                motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { [unowned self](data, error) in
                    if self.fallBehavior.dynamicAnimator != nil {
                        if var dx = data?.gravity.x, var dy = data?.gravity.y {
                            switch UIDevice.current.orientation {
                            case .landscapeLeft: swap(&dx, &dy); dy = -dy; print("landscapeLeft")
                            case .landscapeRight: swap(&dx, &dy); print("landscapeRight")
                            case .portrait: dy = -dy; print("portrait")
                            case .portraitUpsideDown: print("portraitUpsideDown")
                            default: dx = 0; dy = 0
                            }
                            self.fallBehavior.gravity.gravityDirection = CGVector(dx: dx, dy: dy)
                        }
                    } else {
                        self.motionManager.stopDeviceMotionUpdates()
                    }
                })
            }
        } else {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    private var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)
                beizerPaths[PathNames.Attachment] = nil
            }
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
                attachment!.action = {[unowned self] in
                    if let attachedDrop = self.attachment!.items.first as? UIView {
                        let path = UIBezierPath()
                        path.move(to: self.attachment!.anchorPoint)
                        path.addLine(to: attachedDrop.center)
                        self.beizerPaths[PathNames.Attachment] = path
                    }
                }
            }
        }
    }
    
    private struct PathNames {
        static let MiddleBarrier = "Middle Barrier"
        static let Attachment = "Attachment"
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        
        let path = UIBezierPath(ovalIn: CGRect(center: bounds.mid, size: dropSize))
        fallBehavior.addBarrier(path: path, named: PathNames.MiddleBarrier)
        
        beizerPaths[PathNames.MiddleBarrier] = path
    }
    
    func grabDrop(recognizer: UIPanGestureRecognizer) {
        let gesturePoint = recognizer.location(in: self)
        switch recognizer.state {
        case .began:
            if let dropToAttachTo = lastDrop, dropToAttachTo.superview != nil {
                attachment = UIAttachmentBehavior(item: dropToAttachTo, attachedToAnchor: gesturePoint)
            }
            lastDrop = nil
        case .changed:
            attachment?.anchorPoint = gesturePoint
        default:
            attachment = nil
        }
    }
    
    private var dropSize: CGSize {
        let size = self.bounds.size.width / CGFloat(self.dropPerRow)
        return CGSize(width: size, height: size)
    }
    
    private var lastDrop: UIView?
    
    func createDrop(position: CGPoint) {
        var frame = CGRect(origin: CGPoint.zero, size: dropSize)
        frame.origin.x = floor(position.x / dropSize.width) * dropSize.width
        
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        
        self.addSubview(dropView)
        fallBehavior.addItem(dropView)
        lastDrop = dropView
    }
    
    func removeCompleteDrop() {
        var dropsToRemove = [UIView]()
        
        var hitTestRect = CGRect(origin: bounds.lowerLeft, size: dropSize)
        repeat {
            hitTestRect.origin.x = bounds.minX
            hitTestRect.origin.y -= dropSize.height
            var dropsTest = 0
            var dropsFound = [UIView]()
            while dropsTest < dropPerRow {
                if let hitView = hitTest(hitTestRect.mid, with: nil) , hitView.superview == self {
                    dropsFound.append(hitView)
                } else {
                    break
                }
                hitTestRect.origin.x += dropSize.width
                dropsTest += 1
            }
            if dropsTest == dropPerRow {
                dropsToRemove += dropsFound
            }
        }while dropsToRemove.count == 0 && hitTestRect.origin.y > bounds.minY
        
        for drop in dropsToRemove {
            drop.removeFromSuperview()
            fallBehavior.removeItem(drop)
        }
    }
    
}
