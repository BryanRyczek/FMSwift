//
//  AnimationTestingViewController.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/10/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//


import CoreGraphics
import Foundation
import UIKit
import Chameleon
//import PermissionScope


class AnimationTestingViewController: UIViewController {
//    let pscope = PermissionScope()
    
    let wordLayer = CAShapeLayer()
    
    override func viewDidLoad() {
      
        //shutter()
        //flash()
        flashElements()
    }
    
    func shutter () {
        //// Color Declarations
        let color2 = UIColor(red: 0.975, green: 0.927, blue: 0.115, alpha: 1.000)
        let color0 = UIColor(red: 0.103, green: 0.092, blue: 0.095, alpha: 1.000)
        
        //// outerRing Drawing
        let outerRingLayer = CAShapeLayer()
        
        var outerRingPath = UIBezierPath()
        outerRingPath.moveToPoint(CGPointMake(35.97, 0))
        outerRingPath.addCurveToPoint(CGPointMake(72, 35.99), controlPoint1: CGPointMake(55.89, 0), controlPoint2: CGPointMake(72, 16.12))
        outerRingPath.addCurveToPoint(CGPointMake(35.97, 72), controlPoint1: CGPointMake(72, 55.88), controlPoint2: CGPointMake(55.89, 72))
        outerRingPath.addCurveToPoint(CGPointMake(0, 35.99), controlPoint1: CGPointMake(16.12, 72), controlPoint2: CGPointMake(0, 55.88))
        outerRingPath.addCurveToPoint(CGPointMake(35.97, 0), controlPoint1: CGPointMake(-0, 16.12), controlPoint2: CGPointMake(16.11, 0))
        outerRingPath.closePath()
        color0.setStroke()
        outerRingPath.lineWidth = 3
        outerRingPath.stroke()
        
        outerRingLayer.path = outerRingPath.CGPath
        outerRingLayer.fillColor = UIColor.clearColor().CGColor
        outerRingLayer.strokeColor = color0.CGColor
        outerRingLayer.lineWidth = 4
        
        view.layer.addSublayer(outerRingLayer)
        
        /// shutterMask Drawing
        let shutterMaskLayer = CAShapeLayer()
        
        var shutterMaskPath = UIBezierPath()
        shutterMaskPath.moveToPoint(CGPointMake(34.22, 40.96))
        shutterMaskPath.addLineToPoint(CGPointMake(31.49, 38.68))
        shutterMaskPath.addLineToPoint(CGPointMake(30.87, 35.17))
        shutterMaskPath.addLineToPoint(CGPointMake(32.65, 32.08))
        shutterMaskPath.addLineToPoint(CGPointMake(35.97, 30.87))
        shutterMaskPath.addLineToPoint(CGPointMake(39.34, 32.08))
        shutterMaskPath.addLineToPoint(CGPointMake(41.12, 35.17))
        shutterMaskPath.addLineToPoint(CGPointMake(40.5, 38.68))
        shutterMaskPath.addLineToPoint(CGPointMake(37.78, 40.96))
        shutterMaskPath.addLineToPoint(CGPointMake(34.22, 40.96))
        shutterMaskPath.closePath()
        shutterMaskPath.miterLimit = 4;
        
        color0.setFill()
        shutterMaskPath.fill()
        shutterMaskLayer.path = shutterMaskPath.CGPath
        shutterMaskLayer.fillColor = UIColor.blackColor().CGColor
        shutterMaskLayer.strokeColor = UIColor.blackColor().CGColor
       
        shutterMaskLayer.lineWidth = 2
        
        //// innerRing Drawing
        let innerRingLayer = CAShapeLayer()
        
        var innerRingPath = UIBezierPath()
        innerRingPath.moveToPoint(CGPointMake(35.98, 9))
        innerRingPath.addCurveToPoint(CGPointMake(63, 36), controlPoint1: CGPointMake(50.91, 9), controlPoint2: CGPointMake(63, 21.09))
        innerRingPath.addCurveToPoint(CGPointMake(35.98, 63), controlPoint1: CGPointMake(63, 50.91), controlPoint2: CGPointMake(50.91, 63))
        innerRingPath.addCurveToPoint(CGPointMake(9, 36), controlPoint1: CGPointMake(21.1, 63), controlPoint2: CGPointMake(9, 50.91))
        innerRingPath.addCurveToPoint(CGPointMake(35.98, 9), controlPoint1: CGPointMake(9, 21.09), controlPoint2: CGPointMake(21.09, 9))
        innerRingPath.closePath()
        color0.setStroke()
        innerRingPath.lineWidth = 3
        innerRingPath.stroke()
        
        innerRingLayer.path = innerRingPath.CGPath
        innerRingLayer.fillColor = UIColor.redColor().CGColor
        innerRingLayer.strokeColor = UIColor.blackColor().CGColor
        innerRingLayer.lineWidth = 4
        
        view.layer.addSublayer(innerRingLayer)

        
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, innerRingLayer.bounds)
        CGPathAddPath(path, nil, shutterMaskLayer.path);
        shutterMaskLayer.fillRule = kCAFillRuleEvenOdd;
        shutterMaskLayer.fillColor = UIColor.greenColor().CGColor
        shutterMaskLayer.path = path
        innerRingLayer.mask = shutterMaskLayer
        
        let shrinkAnimation = CABasicAnimation(keyPath: "transform.scale")
            shrinkAnimation.fromValue = 4
            shrinkAnimation.toValue = 0.5
            shrinkAnimation.autoreverses = true
            shrinkAnimation.repeatCount = HUGE
            shrinkAnimation.duration = 2
            shrinkAnimation.removedOnCompletion = false
            //shrinkAnimation.fillMode = kCAFillModeBoth
        if let mask = innerRingLayer.mask {
            mask.addAnimation(shrinkAnimation, forKey: nil)
        }
        
        // middleRing Drawing
        let middleRingLayer = CAShapeLayer()
        
        var middleRingPath = UIBezierPath()
        middleRingPath.moveToPoint(CGPointMake(35.97, 4.5))
        middleRingPath.addCurveToPoint(CGPointMake(67.5, 35.99), controlPoint1: CGPointMake(53.39, 4.5), controlPoint2: CGPointMake(67.5, 18.61))
        middleRingPath.addCurveToPoint(CGPointMake(35.97, 67.5), controlPoint1: CGPointMake(67.5, 53.39), controlPoint2: CGPointMake(53.39, 67.5))
        middleRingPath.addCurveToPoint(CGPointMake(4.5, 35.99), controlPoint1: CGPointMake(18.61, 67.5), controlPoint2: CGPointMake(4.5, 53.39))
        middleRingPath.addCurveToPoint(CGPointMake(35.97, 4.5), controlPoint1: CGPointMake(4.5, 18.61), controlPoint2: CGPointMake(18.6, 4.5))
        middleRingPath.closePath()
        color2.setStroke()
        middleRingPath.lineWidth = 6
        middleRingPath.stroke()
        
        middleRingLayer.path = middleRingPath.CGPath
        middleRingLayer.fillColor = UIColor.clearColor().CGColor
        middleRingLayer.strokeColor = color2.CGColor
        middleRingLayer.lineWidth = 4
        
        view.layer.addSublayer(middleRingLayer)
        
       

    }
        // Set the mask of the view.
    
    class func mask(viewToMask: UIView, maskRect: CGRect, invert: Bool = false) {
        let maskLayer = CAShapeLayer()
        let path = CGPathCreateMutable()
        if (invert) {
            CGPathAddRect(path, nil, viewToMask.bounds)
        }
        CGPathAddRect(path, nil, maskRect)
        
        maskLayer.path = path
        if (invert) {
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        // Set the mask of the view.
        viewToMask.layer.mask = maskLayer;
    }

    
    
    func flash () {
        
        let bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        let center = view.center
        
        // Create CAShapeLayerS
        let rectShape1 = CAShapeLayer()
        rectShape1.bounds = bounds
        rectShape1.position = CGPoint(x: center.x, y: center.y - 120)
        view.layer.addSublayer(rectShape1)
        
        // Apply effects here
        // 1
        rectShape1.backgroundColor = UIColor.redColor().CGColor
        rectShape1.cornerRadius = 20
        
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
        flashTopLayer.lineWidth = 0.5
        flashTopLayer.bounds = flashTopPath.bounds
        flashTopLayer.position = CGPoint(x: center.x, y: center.y)
        
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
        flashBottomLayer.lineWidth = 0.5
        flashBottomLayer.bounds = flashBottomPath.bounds
        
        flashBottomLayer.position = CGPoint(x: center.x + 31.14, y: center.y)
        print(flashBottomPath.bounds)
        print(flashBottomLayer.bounds)
        print(flashBottomLayer.position)
        print(flashTopLayer.bounds)
        
        let duration = 1.0
        
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = duration
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 0.868
        animateStrokeEnd.removedOnCompletion = false
        animateStrokeEnd.fillMode = kCAFillModeBoth
        
        // add the animation
        flashTopLayer.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        flashBottomLayer.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        
        view.layer.addSublayer(flashTopLayer)
        view.layer.addSublayer(flashBottomLayer)
        
        let toPoint: CGPoint = CGPointMake(0.0, 15.75)
        let fromPoint : CGPoint = CGPointZero
        let upPoint: CGPoint = CGPointMake(0.0, -15.75)
        
        let animatePosition = CABasicAnimation(keyPath: "position")
        animatePosition.duration = duration
        animatePosition.fromValue = NSValue(CGPoint: fromPoint)
        animatePosition.toValue = NSValue(CGPoint: toPoint)
        animatePosition.additive = true
        animatePosition.fillMode = kCAFillModeBoth // keep to value after finishing
        animatePosition.removedOnCompletion = false // don't remove after finishing
        
        let topAnimation = CABasicAnimation(keyPath: "position")
        topAnimation.duration = duration
        topAnimation.fromValue = NSValue(CGPoint: fromPoint)
        topAnimation.toValue = NSValue(CGPoint: upPoint)
        topAnimation.additive = true
        topAnimation.fillMode = kCAFillModeBoth
        topAnimation.removedOnCompletion = false
        
        flashBottomLayer.addAnimation(animatePosition, forKey: "position")
        flashTopLayer.addAnimation(topAnimation, forKey:"positionUp")
    }
    
    func flashElements () {
        let elements = AnimationLayers()
        let flashTopPath = elements.getPathForShape("flashTop")
        let flashBottomPath = elements.getPathForShape("flashBottom")
        let flashTopLayer = elements.makeShapeLayer(flashTopPath)
        let flashBottomLayer = elements.makeShapeLayer(flashBottomPath)
        
        print("flashtopLayberbounds \(flashTopLayer.bounds), bottom \(flashBottomLayer.bounds)")
        
        let center = self.view.center
        print(center)
        
        flashTopLayer.fillColor = UIColor.redColor().CGColor
        flashTopLayer.strokeColor = UIColor.redColor().CGColor
        flashTopLayer.lineWidth = 0.5
        flashTopLayer.position = CGPoint(x: center.x, y: center.y)
        
        flashBottomLayer.fillColor = UIColor.redColor().CGColor
        flashBottomLayer.strokeColor = UIColor.redColor().CGColor
        flashBottomLayer.lineWidth = 0.5
        flashBottomLayer.position = CGPoint(x: center.x + 31.14, y: center.y)
        
        self.view.layer.addSublayer(flashTopLayer)
        self.view.layer.addSublayer(flashBottomLayer)
        
        print(flashBottomLayer.bounds)
        print(flashBottomLayer.position)
        print(flashTopLayer.bounds)
        
        let duration = 1.0
        
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = duration
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 0.868
        animateStrokeEnd.removedOnCompletion = false
        animateStrokeEnd.fillMode = kCAFillModeBoth
        
        // add the animation
        flashTopLayer.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        flashBottomLayer.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        
        
        let toPoint: CGPoint = CGPointMake(0.0, 15.75)
        let fromPoint : CGPoint = CGPointZero
        let upPoint: CGPoint = CGPointMake(0.0, -15.75)
        
        let animatePosition = CABasicAnimation(keyPath: "position")
        animatePosition.duration = duration
        animatePosition.fromValue = NSValue(CGPoint: fromPoint)
        animatePosition.toValue = NSValue(CGPoint: toPoint)
        animatePosition.additive = true
        animatePosition.fillMode = kCAFillModeBoth // keep to value after finishing
        animatePosition.removedOnCompletion = false // don't remove after finishing
        
        let topAnimation = CABasicAnimation(keyPath: "position")
        topAnimation.duration = duration
        topAnimation.fromValue = NSValue(CGPoint: fromPoint)
        topAnimation.toValue = NSValue(CGPoint: upPoint)
        topAnimation.additive = true
        topAnimation.fillMode = kCAFillModeBoth
        topAnimation.removedOnCompletion = false
        
        flashBottomLayer.addAnimation(animatePosition, forKey: "position")
        flashTopLayer.addAnimation(topAnimation, forKey:"positionUp")
        
    }

    
    //
    //        let animateWord = CABasicAnimation(keyPath: "strokeEnd")
    //        animateWord.duration = 5.0
    //        animateWord.fromValue = 0.0
    //        animateWord.toValue = 1.0
    //
    //        wordLayer.addAnimation(animateWord, forKey: "animate")
    //        //NSProgressIndicator()

    
    // Apply a circle mask on a target view. You can customize radius, color and opacity of the mask.
//    class CircleMaskView {
//        
//        private var fillLayer = CAShapeLayer()
//        var target: UIView?
//        
//        var fillColor: UIColor = UIColor.grayColor() {
//            didSet {
//                self.fillLayer.fillColor = self.fillColor.CGColor
//            }
//        }
//        
//        var radius: CGFloat? {
//            didSet {
//                self.draw()
//            }
//        }
//        
//        var opacity: Float = 0.5 {
//            didSet {
//                self.fillLayer.opacity = self.opacity
//            }
//        }
//        
//        /**
//         Constructor
//         
//         - parameter drawIn: target view
//         
//         - returns: object instance
//         */
//        init(drawIn: UIView) {
//            self.target = drawIn
//        }
//        
//        /**
//         Draw a circle mask on target view
//         */
//        func draw() {
//            guard (let target = target) else {
//                print("target is nil")
//                return
//            }
//            
//            var rad: CGFloat = 0
//            let size = target.frame.size
//            if let r = self.radius {
//                rad = r
//            } else {
//                rad = min(size.height, size.width)
//            }
//            
//            let path = UIBezierPath(roundedRect: CGRectMake(0, 0, size.width, size.height), cornerRadius: 0.0)
//            let circlePath = UIBezierPath(roundedRect: CGRectMake(size.width / 2.0 - rad / 2.0, 0, rad, rad), cornerRadius: rad)
//            path.appendPath(circlePath)
//            path.usesEvenOddFillRule = true
//            
//            fillLayer.path = path.CGPath
//            fillLayer.fillRule = kCAFillRuleEvenOdd
//            fillLayer.fillColor = self.fillColor.CGColor
//            fillLayer.opacity = self.opacity
//            self.target.layer.addSublayer(fillLayer)
//        }
//        
//        /**
//         Remove circle mask
//         */
//        
//        
//        func remove() {
//            self.fillLayer.removeFromSuperlayer()
//        }
//        
//    }
    
    
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
