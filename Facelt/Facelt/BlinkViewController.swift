//
//  BlinkViewController.swift
//  Facelt
//
//  Created by lyxia on 2016/10/6.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import UIKit

class BlinkViewController: FaceViewController {
    private var blink: Bool = false {
        didSet {
            startBlink()
        }
    }
    
    struct BlinkData {
        static let OpenDuring: Double = 1.0
        static let CloseDuring: Double = 0.4
    }
    
    func startBlink() {
        if blink {
            Timer.scheduledTimer(timeInterval: BlinkData.CloseDuring,
                                 target: self,
                                 selector: #selector(BlinkViewController.endBlink),
                                 userInfo: nil,
                                 repeats: false)
            faceView.eyesOpen = false
        }
    }
    
    func endBlink() {
        Timer.scheduledTimer(timeInterval: BlinkData.OpenDuring,
                             target: self,
                             selector: #selector(BlinkViewController.startBlink),
                             userInfo: nil,
                             repeats: false)
        faceView.eyesOpen = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        blink = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        blink = false
    }
}
