//
//  EmotionsViewController.swift
//  Facelt
//
//  Created by lyxia on 2016/9/22.
//  Copyright © 2016年 lyxia. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {
    
    private let faceExpressionDic = [
        "happy": FacialExpression(eyes: .open, eyeBrows: .normal, mouth: .smile),
        "angry": FacialExpression(eyes: .open, eyeBrows: .relaxed, mouth: .neutral),
        "worry": FacialExpression(eyes: .open, eyeBrows: .furrowed, mouth: .frown)
    ]
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destination: UIViewController = segue.destination
        if let nav = destination as? UINavigationController {
            destination = nav.visibleViewController!
        }
          
        if let faceVC = destination as? FaceViewController {
            if let identifier = segue.identifier, let expression = faceExpressionDic[identifier] {
                faceVC.facialExpression = expression
                faceVC.navigationItem.title = segue.identifier
            }
        }
    }
 

}
