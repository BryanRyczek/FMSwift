//
//  Animations.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 2/19/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import Foundation
import UIKit

class AnimationLayers {
    
    //var bounds : CGRect
    //let color3 = UIColor(red: 0.076, green: 0.615, blue: 0.920, alpha: 1.000)

    let duration = 1.0
    
    var layer = CAShapeLayer()
    
    init(name: String = "flashTop") {
        self.layer = makeShapeLayer(getPathForShape(name))
    }
    
    init(name: String, position: CGPoint) {
        self.layer = self.makeShapeLayer(getPathForShape(name))
        self.layer.position = position
    }
    
    func makeShapeLayer(path: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.bounds = path.bounds
        return shapeLayer
    }
    
    func getPathForShape(shapeName: String) -> UIBezierPath {
    
        let path = UIBezierPath()
        
        switch shapeName {
        case "flashTop":
        path.moveToPoint(CGPointMake(31.27, 50.66))
        path.addCurveToPoint(CGPointMake(16.76, 50.66), controlPoint1: CGPointMake(27.49, 50.66), controlPoint2: CGPointMake(20.4, 50.66))
        path.addCurveToPoint(CGPointMake(2.3, 50.67), controlPoint1: CGPointMake(11.94, 50.66), controlPoint2: CGPointMake(7.12, 50.65))
        path.addCurveToPoint(CGPointMake(0.21, 49.77), controlPoint1: CGPointMake(1.45, 50.68), controlPoint2: CGPointMake(0.67, 50.62))
        path.addCurveToPoint(CGPointMake(0.5, 47.59), controlPoint1: CGPointMake(-0.23, 48.97), controlPoint2: CGPointMake(0.09, 48.29))
        path.addCurveToPoint(CGPointMake(21.36, 12.19), controlPoint1: CGPointMake(7.46, 35.79), controlPoint2: CGPointMake(14.41, 23.99))
        path.addCurveToPoint(CGPointMake(27.95, 0.99), controlPoint1: CGPointMake(23.56, 8.46), controlPoint2: CGPointMake(25.76, 4.73))
        path.addCurveToPoint(CGPointMake(29.66, 0), controlPoint1: CGPointMake(28.34, 0.33), controlPoint2: CGPointMake(28.89, -0.05))
        path.addCurveToPoint(CGPointMake(31.14, 1.09), controlPoint1: CGPointMake(30.37, 0.05), controlPoint2: CGPointMake(30.89, 0.42))
        path.addCurveToPoint(CGPointMake(31.26, 2.03), controlPoint1: CGPointMake(31.24, 1.38), controlPoint2: CGPointMake(31.26, 1.71))
        path.addCurveToPoint(CGPointMake(31.27, 29.03), controlPoint1: CGPointMake(31.27, 11.03), controlPoint2: CGPointMake(31.27, 20.03))
        path.addCurveToPoint(CGPointMake(31.27, 29.97), controlPoint1: CGPointMake(31.27, 29.31), controlPoint2: CGPointMake(31.27, 29.6))
        path.addLineToPoint(CGPointMake(31.27, 50.66))
        path.closePath()
        path.usesEvenOddFillRule = true;
        case "flashBottom":
        path.moveToPoint(CGPointMake(31.43, -0.16))
        path.addCurveToPoint(CGPointMake(45.93, -0.16), controlPoint1: CGPointMake(35.2, -0.16), controlPoint2: CGPointMake(42.3, -0.16))
        path.addCurveToPoint(CGPointMake(60.4, -0.17), controlPoint1: CGPointMake(50.76, -0.16), controlPoint2: CGPointMake(55.58, -0.15))
        path.addCurveToPoint(CGPointMake(62.48, 0.73), controlPoint1: CGPointMake(61.25, -0.17), controlPoint2: CGPointMake(62.02, -0.11))
        path.addCurveToPoint(CGPointMake(62.19, 2.92), controlPoint1: CGPointMake(62.92, 1.53), controlPoint2: CGPointMake(62.61, 2.21))
        path.addCurveToPoint(CGPointMake(41.34, 38.31), controlPoint1: CGPointMake(55.24, 14.71), controlPoint2: CGPointMake(48.29, 26.51))
        path.addCurveToPoint(CGPointMake(34.74, 49.51), controlPoint1: CGPointMake(39.14, 42.04), controlPoint2: CGPointMake(36.94, 45.78))
        path.addCurveToPoint(CGPointMake(33.03, 50.5), controlPoint1: CGPointMake(34.35, 50.17), controlPoint2: CGPointMake(33.81, 50.55))
        path.addCurveToPoint(CGPointMake(31.56, 49.42), controlPoint1: CGPointMake(32.32, 50.45), controlPoint2: CGPointMake(31.8, 50.08))
        path.addCurveToPoint(CGPointMake(31.43, 48.47), controlPoint1: CGPointMake(31.45, 49.13), controlPoint2: CGPointMake(31.43, 48.79))
        path.addCurveToPoint(CGPointMake(31.43, 21.48), controlPoint1: CGPointMake(31.43, 39.47), controlPoint2: CGPointMake(31.43, 30.48))
        path.addCurveToPoint(CGPointMake(31.43, 20.53), controlPoint1: CGPointMake(31.43, 21.19), controlPoint2: CGPointMake(31.43, 20.9))
        path.addLineToPoint(CGPointMake(31.43, -0.16))
        path.closePath()
        path.usesEvenOddFillRule = true;
        default:
        break
        }
        return path
        }

}
        