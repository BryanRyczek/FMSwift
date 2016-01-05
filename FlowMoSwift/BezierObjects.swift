//
//  BezierObjects.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 1/5/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit

class BezierObjects: NSObject {

    func flashPath()  {
        
        //// Color Declarations
        let yellowGreen = UIColor(red: 0.626, green: 0.795, blue: 0.164, alpha: 1.000)
        
        //// flashOnFill Drawing
        var flashOnFillPath = UIBezierPath()
        flashOnFillPath.moveToPoint(CGPointMake(7.33, 0.62))
        flashOnFillPath.addLineToPoint(CGPointMake(7.52, 7.68))
        flashOnFillPath.addLineToPoint(CGPointMake(14.74, 7.68))
        flashOnFillPath.addLineToPoint(CGPointMake(7.17, 19.28))
        flashOnFillPath.addLineToPoint(CGPointMake(7.14, 12.25))
        flashOnFillPath.addLineToPoint(CGPointMake(0.55, 12.28))
        flashOnFillPath.addLineToPoint(CGPointMake(7.33, 0.62))
        flashOnFillPath.closePath()
        flashOnFillPath.miterLimit = 4;
        
        flashOnFillPath.usesEvenOddFillRule = true;
        
        yellowGreen.setFill()
        flashOnFillPath.fill()
        
            }
    
}
