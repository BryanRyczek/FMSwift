//
//  FlowMoSlider.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/8/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import UIKit

class FlowMoSlider: UISlider {

    var thumbTouchSize : CGSize = CGSizeMake(200, 200)
    var thumbSize = 200.00
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let bounds = CGRectInset(self.bounds, -thumbTouchSize.width, -thumbTouchSize.height);
        return CGRectContainsPoint(bounds, point);
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let thumbPercent = (value - minimumValue) / (maximumValue - minimumValue)
        //let thumbSize = thumbImageForState(UIControlState.Normal)!.size.height
        let thumbPos = CGFloat(thumbSize) + (CGFloat(thumbPercent) * (CGFloat(bounds.size.width) - (2 * CGFloat(thumbSize))))
        let touchPoint = touch.locationInView(self)
        
        return (touchPoint.x >= (thumbPos - thumbTouchSize.width) &&
            touchPoint.x <= (thumbPos + thumbTouchSize.width))
    }

}
