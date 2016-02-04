//
//  AnimationTestingViewController.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/10/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import Foundation
import UIKit
import Chameleon
//import PermissionScope


class AnimationTestingViewController: UIViewController {
//    let pscope = PermissionScope()
    
    let wordLayer = CAShapeLayer()
    
    override func viewDidLoad() {
      
        
        //// Color Declarations
        let color3 = UIColor(red: 0.076, green: 0.615, blue: 0.920, alpha: 1.000)
        
        let flashTopLayer = CAShapeLayer()
       
        var flashTopPath = UIBezierPath()
        flashTopPath.moveToPoint(CGPointMake(31.27, 50.66))
        flashTopPath.addCurveToPoint(CGPointMake(16.76, 50.66), controlPoint1: CGPointMake(27.49, 50.66), controlPoint2: CGPointMake(20.4, 50.66))
        flashTopPath.addCurveToPoint(CGPointMake(2.3, 50.67), controlPoint1: CGPointMake(11.94, 50.66), controlPoint2: CGPointMake(7.12, 50.65))
        flashTopPath.addCurveToPoint(CGPointMake(0.21, 49.77), controlPoint1: CGPointMake(1.45, 50.68), controlPoint2: CGPointMake(0.67, 50.62))
        flashTopPath.addCurveToPoint(CGPointMake(0.5, 47.59), controlPoint1: CGPointMake(-0.23, 48.97), controlPoint2: CGPointMake(0.09, 48.29))
        flashTopPath.addCurveToPoint(CGPointMake(21.36, 12.19), controlPoint1: CGPointMake(7.46, 35.79), controlPoint2: CGPointMake(14.41, 23.99))
        flashTopPath.addCurveToPoint(CGPointMake(27.95, 0.99), controlPoint1: CGPointMake(23.56, 8.46), controlPoint2: CGPointMake(25.76, 4.73))
        flashTopPath.addCurveToPoint(CGPointMake(29.66, 0), controlPoint1: CGPointMake(28.34, 0.33), controlPoint2: CGPointMake(28.89, -0.05))
        flashTopPath.addCurveToPoint(CGPointMake(31.14, 1.09), controlPoint1: CGPointMake(30.37, 0.05), controlPoint2: CGPointMake(30.89, 0.42))
        flashTopPath.addCurveToPoint(CGPointMake(31.26, 2.03), controlPoint1: CGPointMake(31.24, 1.38), controlPoint2: CGPointMake(31.26, 1.71))
        flashTopPath.addCurveToPoint(CGPointMake(31.27, 29.03), controlPoint1: CGPointMake(31.27, 11.03), controlPoint2: CGPointMake(31.27, 20.03))
        flashTopPath.addCurveToPoint(CGPointMake(31.27, 29.97), controlPoint1: CGPointMake(31.27, 29.31), controlPoint2: CGPointMake(31.27, 29.6))
        flashTopPath.addLineToPoint(CGPointMake(31.27, 50.66))
        flashTopPath.closePath()
        flashTopPath.usesEvenOddFillRule = true;
        
        
        flashTopLayer.path = flashTopPath.CGPath
        flashTopLayer.fillColor = UIColor.clearColor().CGColor
        flashTopLayer.strokeColor = color3.CGColor
        flashTopLayer.lineWidth = 4
        
        let flashBottomLayer = CAShapeLayer()
        
        var flashBottomPath = UIBezierPath()
        flashBottomPath.moveToPoint(CGPointMake(31.43, -0.16))
        flashBottomPath.addCurveToPoint(CGPointMake(45.93, -0.16), controlPoint1: CGPointMake(35.2, -0.16), controlPoint2: CGPointMake(42.3, -0.16))
        flashBottomPath.addCurveToPoint(CGPointMake(60.4, -0.17), controlPoint1: CGPointMake(50.76, -0.16), controlPoint2: CGPointMake(55.58, -0.15))
        flashBottomPath.addCurveToPoint(CGPointMake(62.48, 0.73), controlPoint1: CGPointMake(61.25, -0.17), controlPoint2: CGPointMake(62.02, -0.11))
        flashBottomPath.addCurveToPoint(CGPointMake(62.19, 2.92), controlPoint1: CGPointMake(62.92, 1.53), controlPoint2: CGPointMake(62.61, 2.21))
        flashBottomPath.addCurveToPoint(CGPointMake(41.34, 38.31), controlPoint1: CGPointMake(55.24, 14.71), controlPoint2: CGPointMake(48.29, 26.51))
        flashBottomPath.addCurveToPoint(CGPointMake(34.74, 49.51), controlPoint1: CGPointMake(39.14, 42.04), controlPoint2: CGPointMake(36.94, 45.78))
        flashBottomPath.addCurveToPoint(CGPointMake(33.03, 50.5), controlPoint1: CGPointMake(34.35, 50.17), controlPoint2: CGPointMake(33.81, 50.55))
        flashBottomPath.addCurveToPoint(CGPointMake(31.56, 49.42), controlPoint1: CGPointMake(32.32, 50.45), controlPoint2: CGPointMake(31.8, 50.08))
        flashBottomPath.addCurveToPoint(CGPointMake(31.43, 48.47), controlPoint1: CGPointMake(31.45, 49.13), controlPoint2: CGPointMake(31.43, 48.79))
        flashBottomPath.addCurveToPoint(CGPointMake(31.43, 21.48), controlPoint1: CGPointMake(31.43, 39.47), controlPoint2: CGPointMake(31.43, 30.48))
        flashBottomPath.addCurveToPoint(CGPointMake(31.43, 20.53), controlPoint1: CGPointMake(31.43, 21.19), controlPoint2: CGPointMake(31.43, 20.9))
        flashBottomPath.addLineToPoint(CGPointMake(31.43, -0.16))
        flashBottomPath.closePath()
        flashBottomPath.usesEvenOddFillRule = true;
        
        flashBottomLayer.path = flashBottomPath.CGPath
        flashBottomLayer.fillColor = UIColor.clearColor().CGColor
        flashBottomLayer.strokeColor = color3.CGColor
        flashBottomLayer.lineWidth = 4
    
        
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = 2.0
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 1.0
        
        // add the animation
        flashTopLayer.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        flashBottomLayer.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        
        view.layer.addSublayer(flashTopLayer)
        view.layer.addSublayer(flashBottomLayer)
        
        let animatePosition = CABasicAnimation(keyPath: "position")
        var toPoint: CGPoint = CGPointMake(0.0, 30.0)
        var fromPoint : CGPoint = CGPointZero
        animatePosition.duration = 2.0
        animatePosition.fromValue = NSValue(CGPoint: fromPoint)
        animatePosition.toValue = NSValue(CGPoint: toPoint)
        animatePosition.additive = true
        animatePosition.fillMode = kCAFillModeBoth // keep to value after finishing
        animatePosition.removedOnCompletion = false // don't remove after finishing
        
        flashBottomLayer.addAnimation(animatePosition, forKey: "position")
        
        let animateWord = CABasicAnimation(keyPath: "strokeEnd")
        animateWord.duration = 5.0
        animateWord.fromValue = 0.0
        animateWord.toValue = 1.0
    
        wordLayer.addAnimation(animateWord, forKey: "animate")
        //NSProgressIndicator()
    }
    
//    let permissions = PermissionScope()
    
    // MARK: SETUP METHODS
//    func p() {
//        
//        super.viewDidLoad()
//        
//        //Code to load Camera
//        let status = permissions.statusContacts()
//        print(status)
//        // Permissions
//        permissions.headerLabel.text = "So glad you made it!"
//        permissions.bodyLabel.text = "Lorem Ipsum"
//        permissions.addPermission(CameraPermission(),
//            message: "We steal your memories")
//        permissions.addPermission(MicrophonePermission(),
//            message: "We steal your voice")
//        permissions.addPermission(PhotosPermission(),
//            message: "We save your photos")
//        
//        permissions.show({ finished, results in
//            print("got results \(results)")
//            }, cancelled: { (results) -> Void in
//                print("thing was cancelled")
//        })
//        print(status)
//        
//        switch permissions.statusContacts() {
//        case .Unknown:
//            print("unkown")
//            return
//        case .Unauthorized, .Disabled:
//            print("Unauth")
//            return
//        case .Authorized:
//            print("Auth")
//            return
//        }
//        
//    }
//
//    
//    func NSProgressIndicator() {
//        pscope.addPermission(ContactsPermission(),
//            message: "We use this to steal\r\nyour friends")
//        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
//            message: "We use this to send you\r\nspam and love notes")
//        pscope.addPermission(LocationWhileInUsePermission(),
//            message: "We use this to track\r\nwhere you live")
//        
//        // Show dialog with callbacks
//        pscope.show({ finished, results in
//            print("got results \(results)")
//            }, cancelled: { (results) -> Void in
//                print("thing was cancelled")
//        })   
//    }

}
