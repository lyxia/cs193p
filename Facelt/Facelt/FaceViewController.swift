//
//  ViewController.swift
//  Facelt
//
//  Created by lyxia on 2016/9/20.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(faceView.pinchHandler(gesture:))))
            
            let upSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.upSwipeHandler))
            upSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(upSwipeGestureRecognizer)
            
            let downSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.downSwipeHandler))
            downSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(downSwipeGestureRecognizer)
            
            updateUI()
        }
    }
    
    func upSwipeHandler() {
        facialExpression.mouth = facialExpression.mouth.sadderMouth()
    }
    
    func downSwipeHandler() {
        facialExpression.mouth = facialExpression.mouth.happierMouth()
    }
    
    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        switch facialExpression.eyes {
        case .close:
            facialExpression.eyes = .open
        default:
            facialExpression.eyes = .close
        }
    }
    
    private struct Animation {
        static let ShakeAngle = CGFloat(M_PI / 6)
        static let ShakeDuration = 0.5
    }
    
    @IBAction func shakeHandler(_ sender: UITapGestureRecognizer) {
//        UIView.animate(
//            withDuration: Animation.ShakeDuration,
//            animations: { 
//                self.faceView.transform = self.faceView.transform.rotated(by: Animation.ShakeAngle)
//            },
//            completion: { (finished) in
//                UIView.animate(
//                    withDuration: Animation.ShakeDuration,
//                    animations: {
//                        self.faceView.transform = self.faceView.transform.rotated(by: -Animation.ShakeAngle * 2)
//                    },
//                    completion: { (finished) in
//                        UIView.animate(
//                            withDuration: Animation.ShakeDuration,
//                            animations: {
//                                self.faceView.transform = self.faceView.transform.rotated(by: Animation.ShakeAngle)
//                            },
//                            completion: nil
//                        )
//                    }
//                )
//            }
//        )
        
        let shakeAnimale = rotated(angle: Animation.ShakeAngle) *>> rotated(angle: -Animation.ShakeAngle * 2) *>> rotated(angle: Animation.ShakeAngle)
        shakeAnimale(self.faceView) {
            print("complete all animal")
        }
    }
    
    var facialExpression: FacialExpression = FacialExpression(eyes: .open, eyeBrows: .normal, mouth: .smile) {
        didSet {
            updateUI()
        }
    }
    
    private var eyeBrows = [FacialExpression.EyeBrows.relaxed: -1.0, .normal: 0, .furrowed: 1]
    private var mouth = [FacialExpression.Mouth.frown: -1, .smirk: -0.5, .neutral: 0, .grin: 0.5, .smile: 1]
    
    private func updateUI() {
        if faceView != nil {
            switch facialExpression.eyes {
            case .open: faceView.eyesOpen = true
            case .close: faceView.eyesOpen = false
            case .squinting: break
            }
            faceView.mouthCurvature = mouth[facialExpression.mouth]!
            faceView.eyeBrawTilt = eyeBrows[facialExpression.eyeBrows]!
        }
    }
}

typealias CompleteAnimalHandler = (Void)->Void
func rotated(angle: CGFloat) -> (UIView, CompleteAnimalHandler)->Void {
    return { (rotatedView, complete) in
        UIView.animate(
            withDuration: 0.5,
            animations: {
                rotatedView.transform = rotatedView.transform.rotated(by: angle)
            },
            completion: { (finished) in
                complete()
            }
        )
    }
}
typealias RotationAnimal = (UIView, CompleteAnimalHandler) -> Void

precedencegroup MultiplicationPrecedence {
    associativity: right
}
infix operator *>> :MultiplicationPrecedence
func *>>(animalA: RotationAnimal, animalB: RotationAnimal) -> RotationAnimal {
    return { (view, complete) in
        animalA(view){
            animalB(view){
                complete()
            }
        }
    }
}

