//
//  TextViewController.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/8/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

//CREATED FOR THE EXPRESS PURPOSE OF TESTING NEW CODE. NOT TO BE INCLUDED IN FINAL PROJECT.

//Conor, replace "UISlider?" with "FlowMoSlider?" on lines 17, 26 and 71

import UIKit
import Chameleon

class TextViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var hersheyArray: [UIBezierPath] = []
    
    var hersheyDictionary = [String: UIBezierPath]()
    
    var xOffset : CGFloat = 0
    
    var hersheyOffset = [String: CGFloat]()
    
    var wordLayer = CAShapeLayer()
    
    let wordView = UIView()
    
    let animation = CAKeyframeAnimation()
    
    var flowmoSlider:FlowMoSlider?
    // These number values represent each slider position
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowmoSlider = FlowMoSlider(frame: self.view.bounds)
        self.view.addSubview(flowmoSlider!)
        flowmoSlider!.maximumValue = 100
        flowmoSlider!.minimumValue = 0
        flowmoSlider!.continuous = true
        flowmoSlider!.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        
        flomoLetters()
    }
    
    func flomoLetters() {
        
        //// hersheya Drawing
        var hersheyaPath = UIBezierPath()
        hersheyaPath.moveToPoint(CGPointMake(9, 3))
        hersheyaPath.addLineToPoint(CGPointMake(8, 1))
        hersheyaPath.addLineToPoint(CGPointMake(6, 0))
        hersheyaPath.addLineToPoint(CGPointMake(4, 0))
        hersheyaPath.addLineToPoint(CGPointMake(2, 1))
        hersheyaPath.addLineToPoint(CGPointMake(1, 2))
        hersheyaPath.addLineToPoint(CGPointMake(0, 4))
        hersheyaPath.addLineToPoint(CGPointMake(0, 6))
        hersheyaPath.addLineToPoint(CGPointMake(1, 8))
        hersheyaPath.addLineToPoint(CGPointMake(3, 9))
        hersheyaPath.addLineToPoint(CGPointMake(5, 9))
        hersheyaPath.addLineToPoint(CGPointMake(7, 8))
        hersheyaPath.addLineToPoint(CGPointMake(8, 6))
        hersheyaPath.addLineToPoint(CGPointMake(10, 0))
        hersheyaPath.addLineToPoint(CGPointMake(9, 5))
        hersheyaPath.addLineToPoint(CGPointMake(9, 8))
        hersheyaPath.addLineToPoint(CGPointMake(10, 9))
        hersheyaPath.addLineToPoint(CGPointMake(11, 9))
        hersheyaPath.addLineToPoint(CGPointMake(13, 8))
        hersheyaPath.addLineToPoint(CGPointMake(14, 7))
        hersheyaPath.addLineToPoint(CGPointMake(16, 4))
        hersheyaPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyaPath.lineWidth = 1
        hersheyaPath.stroke()
        
        
        //// hersheyb Drawing
        var hersheybPath = UIBezierPath()
        hersheybPath.moveToPoint(CGPointMake(0, 16))
        hersheybPath.addLineToPoint(CGPointMake(2, 13))
        hersheybPath.addLineToPoint(CGPointMake(5, 8))
        hersheybPath.addLineToPoint(CGPointMake(6, 6))
        hersheybPath.addLineToPoint(CGPointMake(7, 3))
        hersheybPath.addLineToPoint(CGPointMake(7, 1))
        hersheybPath.addLineToPoint(CGPointMake(6, 0))
        hersheybPath.addLineToPoint(CGPointMake(4, 1))
        hersheybPath.addLineToPoint(CGPointMake(3, 3))
        hersheybPath.addLineToPoint(CGPointMake(2, 7))
        hersheybPath.addLineToPoint(CGPointMake(1, 14))
        hersheybPath.addLineToPoint(CGPointMake(1, 20))
        hersheybPath.addLineToPoint(CGPointMake(2, 21))
        hersheybPath.addLineToPoint(CGPointMake(3, 21))
        hersheybPath.addLineToPoint(CGPointMake(5, 20))
        hersheybPath.addLineToPoint(CGPointMake(7, 18))
        hersheybPath.addLineToPoint(CGPointMake(8, 15))
        hersheybPath.addLineToPoint(CGPointMake(8, 12))
        hersheybPath.addLineToPoint(CGPointMake(9, 16))
        hersheybPath.addLineToPoint(CGPointMake(10, 17))
        hersheybPath.addLineToPoint(CGPointMake(12, 17))
        hersheybPath.addLineToPoint(CGPointMake(14, 16))
        hersheybPath.miterLimit = 4;
        
        hersheybPath.lineJoinStyle = CGLineJoin.Round
        
        UIColor.blackColor().setStroke()
        hersheybPath.lineWidth = 1
        hersheybPath.stroke()
        
        
        //// hersheyc Drawing
        var hersheycPath = UIBezierPath()
        hersheycPath.moveToPoint(CGPointMake(7, 2))
        hersheycPath.addLineToPoint(CGPointMake(7, 1))
        hersheycPath.addLineToPoint(CGPointMake(6, 0))
        hersheycPath.addLineToPoint(CGPointMake(4, 0))
        hersheycPath.addLineToPoint(CGPointMake(2, 1))
        hersheycPath.addLineToPoint(CGPointMake(1, 2))
        hersheycPath.addLineToPoint(CGPointMake(0, 4))
        hersheycPath.addLineToPoint(CGPointMake(0, 6))
        hersheycPath.addLineToPoint(CGPointMake(1, 8))
        hersheycPath.addLineToPoint(CGPointMake(3, 9))
        hersheycPath.addLineToPoint(CGPointMake(6, 9))
        hersheycPath.addLineToPoint(CGPointMake(9, 7))
        hersheycPath.addLineToPoint(CGPointMake(11, 4))
        hersheycPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheycPath.lineWidth = 1
        hersheycPath.stroke()
        
        
        //// hersheyd Drawing
        var hersheydPath = UIBezierPath()
        hersheydPath.moveToPoint(CGPointMake(9, 15))
        hersheydPath.addLineToPoint(CGPointMake(8, 13))
        hersheydPath.addLineToPoint(CGPointMake(6, 12))
        hersheydPath.addLineToPoint(CGPointMake(4, 12))
        hersheydPath.addLineToPoint(CGPointMake(2, 13))
        hersheydPath.addLineToPoint(CGPointMake(1, 14))
        hersheydPath.addLineToPoint(CGPointMake(0, 16))
        hersheydPath.addLineToPoint(CGPointMake(0, 18))
        hersheydPath.addLineToPoint(CGPointMake(1, 20))
        hersheydPath.addLineToPoint(CGPointMake(3, 21))
        hersheydPath.addLineToPoint(CGPointMake(5, 21))
        hersheydPath.addLineToPoint(CGPointMake(7, 20))
        hersheydPath.addLineToPoint(CGPointMake(8, 18))
        hersheydPath.addLineToPoint(CGPointMake(14, 0))
        hersheydPath.moveToPoint(CGPointMake(10, 12))
        hersheydPath.addLineToPoint(CGPointMake(9, 17))
        hersheydPath.addLineToPoint(CGPointMake(9, 20))
        hersheydPath.addLineToPoint(CGPointMake(10, 21))
        hersheydPath.addLineToPoint(CGPointMake(11, 21))
        hersheydPath.addLineToPoint(CGPointMake(13, 20))
        hersheydPath.addLineToPoint(CGPointMake(14, 19))
        hersheydPath.addLineToPoint(CGPointMake(16, 16))
        hersheydPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheydPath.lineWidth = 1
        hersheydPath.stroke()
        
        
        //// hersheye Drawing
        var hersheyePath = UIBezierPath()
        hersheyePath.moveToPoint(CGPointMake(1, 7))
        hersheyePath.addLineToPoint(CGPointMake(3, 6))
        hersheyePath.addLineToPoint(CGPointMake(4, 5))
        hersheyePath.addLineToPoint(CGPointMake(5, 3))
        hersheyePath.addLineToPoint(CGPointMake(5, 1))
        hersheyePath.addLineToPoint(CGPointMake(4, 0))
        hersheyePath.addLineToPoint(CGPointMake(3, 0))
        hersheyePath.addLineToPoint(CGPointMake(1, 1))
        hersheyePath.addLineToPoint(CGPointMake(0, 3))
        hersheyePath.addLineToPoint(CGPointMake(0, 6))
        hersheyePath.addLineToPoint(CGPointMake(1, 8))
        hersheyePath.addLineToPoint(CGPointMake(3, 9))
        hersheyePath.addLineToPoint(CGPointMake(5, 9))
        hersheyePath.addLineToPoint(CGPointMake(7, 8))
        hersheyePath.addLineToPoint(CGPointMake(8, 7))
        hersheyePath.addLineToPoint(CGPointMake(10, 4))
        hersheyePath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyePath.lineWidth = 1
        hersheyePath.stroke()
        
        
        //// hersheyf Drawing
        var hersheyfPath = UIBezierPath()
        hersheyfPath.moveToPoint(CGPointMake(5, 16))
        hersheyfPath.addLineToPoint(CGPointMake(9, 11))
        hersheyfPath.addLineToPoint(CGPointMake(11, 8))
        hersheyfPath.addLineToPoint(CGPointMake(12, 6))
        hersheyfPath.addLineToPoint(CGPointMake(13, 3))
        hersheyfPath.addLineToPoint(CGPointMake(13, 1))
        hersheyfPath.addLineToPoint(CGPointMake(12, 0))
        hersheyfPath.addLineToPoint(CGPointMake(10, 1))
        hersheyfPath.addLineToPoint(CGPointMake(9, 3))
        hersheyfPath.addLineToPoint(CGPointMake(7, 11))
        hersheyfPath.addLineToPoint(CGPointMake(4, 20))
        hersheyfPath.addLineToPoint(CGPointMake(1, 27))
        hersheyfPath.addLineToPoint(CGPointMake(0, 30))
        hersheyfPath.addLineToPoint(CGPointMake(0, 32))
        hersheyfPath.addLineToPoint(CGPointMake(1, 33))
        hersheyfPath.addLineToPoint(CGPointMake(3, 32))
        hersheyfPath.addLineToPoint(CGPointMake(4, 29))
        hersheyfPath.addLineToPoint(CGPointMake(5, 20))
        hersheyfPath.addLineToPoint(CGPointMake(6, 21))
        hersheyfPath.addLineToPoint(CGPointMake(8, 21))
        hersheyfPath.addLineToPoint(CGPointMake(10, 20))
        hersheyfPath.addLineToPoint(CGPointMake(11, 19))
        hersheyfPath.addLineToPoint(CGPointMake(13, 16))
        hersheyfPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyfPath.lineWidth = 1
        hersheyfPath.stroke()
        
        
        //// hersheyg Drawing
        var hersheygPath = UIBezierPath()
        hersheygPath.moveToPoint(CGPointMake(9, 3))
        hersheygPath.addLineToPoint(CGPointMake(8, 1))
        hersheygPath.addLineToPoint(CGPointMake(6, 0))
        hersheygPath.addLineToPoint(CGPointMake(4, 0))
        hersheygPath.addLineToPoint(CGPointMake(2, 1))
        hersheygPath.addLineToPoint(CGPointMake(1, 2))
        hersheygPath.addLineToPoint(CGPointMake(0, 4))
        hersheygPath.addLineToPoint(CGPointMake(0, 6))
        hersheygPath.addLineToPoint(CGPointMake(1, 8))
        hersheygPath.addLineToPoint(CGPointMake(3, 9))
        hersheygPath.addLineToPoint(CGPointMake(5, 9))
        hersheygPath.addLineToPoint(CGPointMake(7, 8))
        hersheygPath.addLineToPoint(CGPointMake(8, 7))
        hersheygPath.moveToPoint(CGPointMake(10, 0))
        hersheygPath.addLineToPoint(CGPointMake(8, 7))
        hersheygPath.addLineToPoint(CGPointMake(4, 18))
        hersheygPath.addLineToPoint(CGPointMake(3, 20))
        hersheygPath.addLineToPoint(CGPointMake(1, 21))
        hersheygPath.addLineToPoint(CGPointMake(0, 20))
        hersheygPath.addLineToPoint(CGPointMake(0, 18))
        hersheygPath.addLineToPoint(CGPointMake(1, 15))
        hersheygPath.addLineToPoint(CGPointMake(4, 12))
        hersheygPath.addLineToPoint(CGPointMake(7, 10))
        hersheygPath.addLineToPoint(CGPointMake(9, 9))
        hersheygPath.addLineToPoint(CGPointMake(12, 7))
        hersheygPath.addLineToPoint(CGPointMake(15, 4))
        hersheygPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheygPath.lineWidth = 1
        hersheygPath.stroke()
        
        
        //// hersheyh Drawing
        var hersheyhPath = UIBezierPath()
        hersheyhPath.moveToPoint(CGPointMake(0, 16))
        hersheyhPath.addLineToPoint(CGPointMake(2, 13))
        hersheyhPath.addLineToPoint(CGPointMake(5, 8))
        hersheyhPath.addLineToPoint(CGPointMake(6, 6))
        hersheyhPath.addLineToPoint(CGPointMake(7, 3))
        hersheyhPath.addLineToPoint(CGPointMake(7, 1))
        hersheyhPath.addLineToPoint(CGPointMake(6, 0))
        hersheyhPath.addLineToPoint(CGPointMake(4, 1))
        hersheyhPath.addLineToPoint(CGPointMake(3, 3))
        hersheyhPath.addLineToPoint(CGPointMake(2, 7))
        hersheyhPath.addLineToPoint(CGPointMake(1, 13))
        hersheyhPath.addLineToPoint(CGPointMake(0, 21))
        hersheyhPath.moveToPoint(CGPointMake(0, 21))
        hersheyhPath.addLineToPoint(CGPointMake(1, 18))
        hersheyhPath.addLineToPoint(CGPointMake(2, 16))
        hersheyhPath.addLineToPoint(CGPointMake(4, 13))
        hersheyhPath.addLineToPoint(CGPointMake(6, 12))
        hersheyhPath.addLineToPoint(CGPointMake(8, 12))
        hersheyhPath.addLineToPoint(CGPointMake(9, 13))
        hersheyhPath.addLineToPoint(CGPointMake(9, 15))
        hersheyhPath.addLineToPoint(CGPointMake(8, 18))
        hersheyhPath.addLineToPoint(CGPointMake(8, 20))
        hersheyhPath.addLineToPoint(CGPointMake(9, 21))
        hersheyhPath.addLineToPoint(CGPointMake(10, 21))
        hersheyhPath.addLineToPoint(CGPointMake(12, 20))
        hersheyhPath.addLineToPoint(CGPointMake(13, 19))
        hersheyhPath.addLineToPoint(CGPointMake(15, 16))
        hersheyhPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyhPath.lineWidth = 1
        hersheyhPath.stroke()
        
        
        //// hersheyi Drawing
        var hersheyiPath = UIBezierPath()
        hersheyiPath.moveToPoint(CGPointMake(3, 0))
        hersheyiPath.addLineToPoint(CGPointMake(3, 1))
        hersheyiPath.addLineToPoint(CGPointMake(4, 1))
        hersheyiPath.addLineToPoint(CGPointMake(4, 0))
        hersheyiPath.addLineToPoint(CGPointMake(3, 0))
        hersheyiPath.closePath()
        hersheyiPath.moveToPoint(CGPointMake(0, 9))
        hersheyiPath.addLineToPoint(CGPointMake(2, 5))
        hersheyiPath.addLineToPoint(CGPointMake(0, 11))
        hersheyiPath.addLineToPoint(CGPointMake(0, 13))
        hersheyiPath.addLineToPoint(CGPointMake(1, 14))
        hersheyiPath.addLineToPoint(CGPointMake(2, 14))
        hersheyiPath.addLineToPoint(CGPointMake(4, 13))
        hersheyiPath.addLineToPoint(CGPointMake(5, 12))
        hersheyiPath.addLineToPoint(CGPointMake(7, 9))
        hersheyiPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyiPath.lineWidth = 1
        hersheyiPath.stroke()
        
        
        //// hersheyj Drawing
        var hersheyjPath = UIBezierPath()
        hersheyjPath.moveToPoint(CGPointMake(11, 0))
        hersheyjPath.addLineToPoint(CGPointMake(11, 1))
        hersheyjPath.addLineToPoint(CGPointMake(12, 1))
        hersheyjPath.addLineToPoint(CGPointMake(12, 0))
        hersheyjPath.addLineToPoint(CGPointMake(11, 0))
        hersheyjPath.closePath()
        hersheyjPath.moveToPoint(CGPointMake(8, 9))
        hersheyjPath.addLineToPoint(CGPointMake(10, 5))
        hersheyjPath.addLineToPoint(CGPointMake(4, 23))
        hersheyjPath.addLineToPoint(CGPointMake(3, 25))
        hersheyjPath.addLineToPoint(CGPointMake(1, 26))
        hersheyjPath.addLineToPoint(CGPointMake(0, 25))
        hersheyjPath.addLineToPoint(CGPointMake(0, 23))
        hersheyjPath.addLineToPoint(CGPointMake(1, 20))
        hersheyjPath.addLineToPoint(CGPointMake(4, 17))
        hersheyjPath.addLineToPoint(CGPointMake(7, 15))
        hersheyjPath.addLineToPoint(CGPointMake(9, 14))
        hersheyjPath.addLineToPoint(CGPointMake(12, 12))
        hersheyjPath.addLineToPoint(CGPointMake(15, 9))
        hersheyjPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyjPath.lineWidth = 1
        hersheyjPath.stroke()
        
        
        //// hersheyk Drawing
        var hersheykPath = UIBezierPath()
        hersheykPath.moveToPoint(CGPointMake(0, 16))
        hersheykPath.addLineToPoint(CGPointMake(2, 13))
        hersheykPath.addLineToPoint(CGPointMake(5, 8))
        hersheykPath.addLineToPoint(CGPointMake(6, 6))
        hersheykPath.addLineToPoint(CGPointMake(7, 3))
        hersheykPath.addLineToPoint(CGPointMake(7, 1))
        hersheykPath.addLineToPoint(CGPointMake(6, 0))
        hersheykPath.addLineToPoint(CGPointMake(4, 1))
        hersheykPath.addLineToPoint(CGPointMake(3, 3))
        hersheykPath.addLineToPoint(CGPointMake(2, 7))
        hersheykPath.addLineToPoint(CGPointMake(1, 13))
        hersheykPath.addLineToPoint(CGPointMake(0, 21))
        hersheykPath.moveToPoint(CGPointMake(0, 21))
        hersheykPath.addLineToPoint(CGPointMake(1, 18))
        hersheykPath.addLineToPoint(CGPointMake(2, 16))
        hersheykPath.addLineToPoint(CGPointMake(4, 13))
        hersheykPath.addLineToPoint(CGPointMake(6, 12))
        hersheykPath.addLineToPoint(CGPointMake(8, 12))
        hersheykPath.addLineToPoint(CGPointMake(9, 13))
        hersheykPath.addLineToPoint(CGPointMake(9, 15))
        hersheykPath.addLineToPoint(CGPointMake(7, 16))
        hersheykPath.addLineToPoint(CGPointMake(4, 16))
        hersheykPath.moveToPoint(CGPointMake(4, 16))
        hersheykPath.addLineToPoint(CGPointMake(6, 17))
        hersheykPath.addLineToPoint(CGPointMake(7, 20))
        hersheykPath.addLineToPoint(CGPointMake(8, 21))
        hersheykPath.addLineToPoint(CGPointMake(9, 21))
        hersheykPath.addLineToPoint(CGPointMake(11, 20))
        hersheykPath.addLineToPoint(CGPointMake(12, 19))
        hersheykPath.addLineToPoint(CGPointMake(14, 16))
        hersheykPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheykPath.lineWidth = 1
        hersheykPath.stroke()
        
        
        //// hersheyl Drawing
        var hersheylPath = UIBezierPath()
        hersheylPath.moveToPoint(CGPointMake(0, 16))
        hersheylPath.addLineToPoint(CGPointMake(2, 13))
        hersheylPath.addLineToPoint(CGPointMake(5, 8))
        hersheylPath.addLineToPoint(CGPointMake(6, 6))
        hersheylPath.addLineToPoint(CGPointMake(7, 3))
        hersheylPath.addLineToPoint(CGPointMake(7, 1))
        hersheylPath.addLineToPoint(CGPointMake(6, 0))
        hersheylPath.addLineToPoint(CGPointMake(4, 1))
        hersheylPath.addLineToPoint(CGPointMake(3, 3))
        hersheylPath.addLineToPoint(CGPointMake(2, 7))
        hersheylPath.addLineToPoint(CGPointMake(1, 14))
        hersheylPath.addLineToPoint(CGPointMake(1, 20))
        hersheylPath.addLineToPoint(CGPointMake(2, 21))
        hersheylPath.addLineToPoint(CGPointMake(3, 21))
        hersheylPath.addLineToPoint(CGPointMake(5, 20))
        hersheylPath.addLineToPoint(CGPointMake(6, 19))
        hersheylPath.addLineToPoint(CGPointMake(8, 16))
        hersheylPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheylPath.lineWidth = 1
        hersheylPath.stroke()
        
        
        //// hersheym Drawing
        var hersheymPath = UIBezierPath()
        hersheymPath.moveToPoint(CGPointMake(0, 4))
        hersheymPath.addLineToPoint(CGPointMake(2, 1))
        hersheymPath.addLineToPoint(CGPointMake(4, 0))
        hersheymPath.addLineToPoint(CGPointMake(5, 1))
        hersheymPath.addLineToPoint(CGPointMake(5, 2))
        hersheymPath.addLineToPoint(CGPointMake(4, 6))
        hersheymPath.addLineToPoint(CGPointMake(3, 9))
        hersheymPath.moveToPoint(CGPointMake(4, 6))
        hersheymPath.addLineToPoint(CGPointMake(5, 4))
        hersheymPath.addLineToPoint(CGPointMake(7, 1))
        hersheymPath.addLineToPoint(CGPointMake(9, 0))
        hersheymPath.addLineToPoint(CGPointMake(11, 0))
        hersheymPath.addLineToPoint(CGPointMake(12, 1))
        hersheymPath.addLineToPoint(CGPointMake(12, 2))
        hersheymPath.addLineToPoint(CGPointMake(11, 6))
        hersheymPath.addLineToPoint(CGPointMake(10, 9))
        hersheymPath.moveToPoint(CGPointMake(11, 6))
        hersheymPath.addLineToPoint(CGPointMake(12, 4))
        hersheymPath.addLineToPoint(CGPointMake(14, 1))
        hersheymPath.addLineToPoint(CGPointMake(16, 0))
        hersheymPath.addLineToPoint(CGPointMake(18, 0))
        hersheymPath.addLineToPoint(CGPointMake(19, 1))
        hersheymPath.addLineToPoint(CGPointMake(19, 3))
        hersheymPath.addLineToPoint(CGPointMake(18, 6))
        hersheymPath.addLineToPoint(CGPointMake(18, 8))
        hersheymPath.addLineToPoint(CGPointMake(19, 9))
        hersheymPath.addLineToPoint(CGPointMake(20, 9))
        hersheymPath.addLineToPoint(CGPointMake(22, 8))
        hersheymPath.addLineToPoint(CGPointMake(23, 7))
        hersheymPath.addLineToPoint(CGPointMake(25, 4))
        hersheymPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheymPath.lineWidth = 1
        hersheymPath.stroke()
        
        
        //// hersheyn Drawing
        var hersheynPath = UIBezierPath()
        hersheynPath.moveToPoint(CGPointMake(0, 4))
        hersheynPath.addLineToPoint(CGPointMake(2, 1))
        hersheynPath.addLineToPoint(CGPointMake(4, 0))
        hersheynPath.addLineToPoint(CGPointMake(5, 1))
        hersheynPath.addLineToPoint(CGPointMake(5, 2))
        hersheynPath.addLineToPoint(CGPointMake(4, 6))
        hersheynPath.addLineToPoint(CGPointMake(3, 9))
        hersheynPath.moveToPoint(CGPointMake(4, 6))
        hersheynPath.addLineToPoint(CGPointMake(5, 4))
        hersheynPath.addLineToPoint(CGPointMake(7, 1))
        hersheynPath.addLineToPoint(CGPointMake(9, 0))
        hersheynPath.addLineToPoint(CGPointMake(11, 0))
        hersheynPath.addLineToPoint(CGPointMake(12, 1))
        hersheynPath.addLineToPoint(CGPointMake(12, 3))
        hersheynPath.addLineToPoint(CGPointMake(11, 6))
        hersheynPath.addLineToPoint(CGPointMake(11, 8))
        hersheynPath.addLineToPoint(CGPointMake(12, 9))
        hersheynPath.addLineToPoint(CGPointMake(13, 9))
        hersheynPath.addLineToPoint(CGPointMake(15, 8))
        hersheynPath.addLineToPoint(CGPointMake(16, 7))
        hersheynPath.addLineToPoint(CGPointMake(18, 4))
        hersheynPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheynPath.lineWidth = 1
        hersheynPath.stroke()
        
        
        //// hersheyo Drawing
        var hersheyoPath = UIBezierPath()
        hersheyoPath.moveToPoint(CGPointMake(6, 0))
        hersheyoPath.addLineToPoint(CGPointMake(4, 0))
        hersheyoPath.addLineToPoint(CGPointMake(2, 1))
        hersheyoPath.addLineToPoint(CGPointMake(1, 2))
        hersheyoPath.addLineToPoint(CGPointMake(0, 4))
        hersheyoPath.addLineToPoint(CGPointMake(0, 6))
        hersheyoPath.addLineToPoint(CGPointMake(1, 8))
        hersheyoPath.addLineToPoint(CGPointMake(3, 9))
        hersheyoPath.addLineToPoint(CGPointMake(5, 9))
        hersheyoPath.addLineToPoint(CGPointMake(7, 8))
        hersheyoPath.addLineToPoint(CGPointMake(8, 7))
        hersheyoPath.addLineToPoint(CGPointMake(9, 5))
        hersheyoPath.addLineToPoint(CGPointMake(9, 3))
        hersheyoPath.addLineToPoint(CGPointMake(8, 1))
        hersheyoPath.addLineToPoint(CGPointMake(6, 0))
        hersheyoPath.addLineToPoint(CGPointMake(5, 1))
        hersheyoPath.addLineToPoint(CGPointMake(5, 3))
        hersheyoPath.addLineToPoint(CGPointMake(6, 5))
        hersheyoPath.addLineToPoint(CGPointMake(8, 6))
        hersheyoPath.addLineToPoint(CGPointMake(11, 6))
        hersheyoPath.addLineToPoint(CGPointMake(13, 5))
        hersheyoPath.addLineToPoint(CGPointMake(14, 4))
        hersheyoPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyoPath.lineWidth = 1
        hersheyoPath.stroke()
        
        
        //// hersheyp Drawing
        var hersheypPath = UIBezierPath()
        hersheypPath.moveToPoint(CGPointMake(4, 5))
        hersheypPath.addLineToPoint(CGPointMake(6, 2))
        hersheypPath.addLineToPoint(CGPointMake(7, 0))
        hersheypPath.addLineToPoint(CGPointMake(6, 4))
        hersheypPath.addLineToPoint(CGPointMake(0, 22))
        hersheypPath.moveToPoint(CGPointMake(6, 4))
        hersheypPath.addLineToPoint(CGPointMake(7, 2))
        hersheypPath.addLineToPoint(CGPointMake(9, 1))
        hersheypPath.addLineToPoint(CGPointMake(11, 1))
        hersheypPath.addLineToPoint(CGPointMake(13, 2))
        hersheypPath.addLineToPoint(CGPointMake(14, 4))
        hersheypPath.addLineToPoint(CGPointMake(14, 6))
        hersheypPath.addLineToPoint(CGPointMake(13, 8))
        hersheypPath.addLineToPoint(CGPointMake(12, 9))
        hersheypPath.addLineToPoint(CGPointMake(10, 10))
        hersheypPath.moveToPoint(CGPointMake(6, 9))
        hersheypPath.addLineToPoint(CGPointMake(8, 10))
        hersheypPath.addLineToPoint(CGPointMake(11, 10))
        hersheypPath.addLineToPoint(CGPointMake(14, 9))
        hersheypPath.addLineToPoint(CGPointMake(16, 8))
        hersheypPath.addLineToPoint(CGPointMake(19, 5))
        hersheypPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheypPath.lineWidth = 1
        hersheypPath.stroke()
        
        
        //// hersheyq Drawing
        var hersheyqPath = UIBezierPath()
        hersheyqPath.moveToPoint(CGPointMake(9, 3))
        hersheyqPath.addLineToPoint(CGPointMake(8, 1))
        hersheyqPath.addLineToPoint(CGPointMake(6, 0))
        hersheyqPath.addLineToPoint(CGPointMake(4, 0))
        hersheyqPath.addLineToPoint(CGPointMake(2, 1))
        hersheyqPath.addLineToPoint(CGPointMake(1, 2))
        hersheyqPath.addLineToPoint(CGPointMake(0, 4))
        hersheyqPath.addLineToPoint(CGPointMake(0, 6))
        hersheyqPath.addLineToPoint(CGPointMake(1, 8))
        hersheyqPath.addLineToPoint(CGPointMake(3, 9))
        hersheyqPath.addLineToPoint(CGPointMake(5, 9))
        hersheyqPath.addLineToPoint(CGPointMake(7, 8))
        hersheyqPath.moveToPoint(CGPointMake(10, 0))
        hersheyqPath.addLineToPoint(CGPointMake(9, 3))
        hersheyqPath.addLineToPoint(CGPointMake(7, 8))
        hersheyqPath.addLineToPoint(CGPointMake(4, 15))
        hersheyqPath.addLineToPoint(CGPointMake(3, 18))
        hersheyqPath.addLineToPoint(CGPointMake(3, 20))
        hersheyqPath.addLineToPoint(CGPointMake(4, 21))
        hersheyqPath.addLineToPoint(CGPointMake(6, 20))
        hersheyqPath.addLineToPoint(CGPointMake(7, 17))
        hersheyqPath.addLineToPoint(CGPointMake(7, 10))
        hersheyqPath.addLineToPoint(CGPointMake(9, 9))
        hersheyqPath.addLineToPoint(CGPointMake(12, 7))
        hersheyqPath.addLineToPoint(CGPointMake(15, 4))
        hersheyqPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyqPath.lineWidth = 1
        hersheyqPath.stroke()
        
        
        //// hersheyr Drawing
        var hersheyrPath = UIBezierPath()
        hersheyrPath.moveToPoint(CGPointMake(0, 5))
        hersheyrPath.addLineToPoint(CGPointMake(2, 2))
        hersheyrPath.addLineToPoint(CGPointMake(3, 0))
        hersheyrPath.addLineToPoint(CGPointMake(3, 2))
        hersheyrPath.addLineToPoint(CGPointMake(6, 2))
        hersheyrPath.addLineToPoint(CGPointMake(7, 3))
        hersheyrPath.addLineToPoint(CGPointMake(7, 5))
        hersheyrPath.addLineToPoint(CGPointMake(6, 8))
        hersheyrPath.addLineToPoint(CGPointMake(6, 9))
        hersheyrPath.addLineToPoint(CGPointMake(7, 10))
        hersheyrPath.addLineToPoint(CGPointMake(8, 10))
        hersheyrPath.addLineToPoint(CGPointMake(10, 9))
        hersheyrPath.addLineToPoint(CGPointMake(11, 8))
        hersheyrPath.addLineToPoint(CGPointMake(13, 5))
        hersheyrPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyrPath.lineWidth = 1
        hersheyrPath.stroke()
        
        
        //// hersheys Drawing
        var hersheysPath = UIBezierPath()
        hersheysPath.moveToPoint(CGPointMake(0, 5))
        hersheysPath.addLineToPoint(CGPointMake(2, 2))
        hersheysPath.addLineToPoint(CGPointMake(3, 0))
        hersheysPath.addLineToPoint(CGPointMake(3, 2))
        hersheysPath.addLineToPoint(CGPointMake(5, 5))
        hersheysPath.addLineToPoint(CGPointMake(6, 7))
        hersheysPath.addLineToPoint(CGPointMake(6, 9))
        hersheysPath.addLineToPoint(CGPointMake(4, 10))
        hersheysPath.moveToPoint(CGPointMake(0, 9))
        hersheysPath.addLineToPoint(CGPointMake(2, 10))
        hersheysPath.addLineToPoint(CGPointMake(6, 10))
        hersheysPath.addLineToPoint(CGPointMake(8, 9))
        hersheysPath.addLineToPoint(CGPointMake(9, 8))
        hersheysPath.addLineToPoint(CGPointMake(11, 5))
        hersheysPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheysPath.lineWidth = 1
        hersheysPath.stroke()
        
        
        //// hersheyt Drawing
        var hersheytPath = UIBezierPath()
        hersheytPath.moveToPoint(CGPointMake(0, 16))
        hersheytPath.addLineToPoint(CGPointMake(2, 13))
        hersheytPath.addLineToPoint(CGPointMake(4, 9))
        hersheytPath.moveToPoint(CGPointMake(7, 0))
        hersheytPath.addLineToPoint(CGPointMake(1, 18))
        hersheytPath.addLineToPoint(CGPointMake(1, 20))
        hersheytPath.addLineToPoint(CGPointMake(2, 21))
        hersheytPath.addLineToPoint(CGPointMake(4, 21))
        hersheytPath.addLineToPoint(CGPointMake(6, 20))
        hersheytPath.addLineToPoint(CGPointMake(7, 19))
        hersheytPath.addLineToPoint(CGPointMake(9, 16))
        hersheytPath.moveToPoint(CGPointMake(1, 8))
        hersheytPath.addLineToPoint(CGPointMake(8, 8))
        hersheytPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheytPath.lineWidth = 1
        hersheytPath.stroke()
        
        
        //// hersheyu Drawing
        var hersheyuPath = UIBezierPath()
        hersheyuPath.moveToPoint(CGPointMake(0, 4))
        hersheyuPath.addLineToPoint(CGPointMake(2, 0))
        hersheyuPath.addLineToPoint(CGPointMake(0, 6))
        hersheyuPath.addLineToPoint(CGPointMake(0, 8))
        hersheyuPath.addLineToPoint(CGPointMake(1, 9))
        hersheyuPath.addLineToPoint(CGPointMake(3, 9))
        hersheyuPath.addLineToPoint(CGPointMake(5, 8))
        hersheyuPath.addLineToPoint(CGPointMake(7, 6))
        hersheyuPath.addLineToPoint(CGPointMake(9, 3))
        hersheyuPath.moveToPoint(CGPointMake(10, 0))
        hersheyuPath.addLineToPoint(CGPointMake(8, 6))
        hersheyuPath.addLineToPoint(CGPointMake(8, 8))
        hersheyuPath.addLineToPoint(CGPointMake(9, 9))
        hersheyuPath.addLineToPoint(CGPointMake(10, 9))
        hersheyuPath.addLineToPoint(CGPointMake(12, 8))
        hersheyuPath.addLineToPoint(CGPointMake(13, 7))
        hersheyuPath.addLineToPoint(CGPointMake(15, 4))
        hersheyuPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyuPath.lineWidth = 1
        hersheyuPath.stroke()
        
        
        //// hersheyv Drawing
        var hersheyvPath = UIBezierPath()
        hersheyvPath.moveToPoint(CGPointMake(0, 4))
        hersheyvPath.addLineToPoint(CGPointMake(2, 0))
        hersheyvPath.addLineToPoint(CGPointMake(1, 5))
        hersheyvPath.addLineToPoint(CGPointMake(1, 8))
        hersheyvPath.addLineToPoint(CGPointMake(2, 9))
        hersheyvPath.addLineToPoint(CGPointMake(3, 9))
        hersheyvPath.addLineToPoint(CGPointMake(6, 8))
        hersheyvPath.addLineToPoint(CGPointMake(8, 6))
        hersheyvPath.addLineToPoint(CGPointMake(9, 3))
        hersheyvPath.addLineToPoint(CGPointMake(9, 0))
        hersheyvPath.moveToPoint(CGPointMake(9, 0))
        hersheyvPath.addLineToPoint(CGPointMake(10, 4))
        hersheyvPath.addLineToPoint(CGPointMake(11, 5))
        hersheyvPath.addLineToPoint(CGPointMake(13, 5))
        hersheyvPath.addLineToPoint(CGPointMake(15, 4))
        hersheyvPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyvPath.lineWidth = 1
        hersheyvPath.stroke()
        
        
        //// hersheyw Drawing
        var hersheywPath = UIBezierPath()
        hersheywPath.moveToPoint(CGPointMake(3, 0))
        hersheywPath.addLineToPoint(CGPointMake(1, 2))
        hersheywPath.addLineToPoint(CGPointMake(0, 5))
        hersheywPath.addLineToPoint(CGPointMake(0, 7))
        hersheywPath.addLineToPoint(CGPointMake(1, 9))
        hersheywPath.addLineToPoint(CGPointMake(3, 9))
        hersheywPath.addLineToPoint(CGPointMake(5, 8))
        hersheywPath.addLineToPoint(CGPointMake(7, 6))
        hersheywPath.moveToPoint(CGPointMake(9, 0))
        hersheywPath.addLineToPoint(CGPointMake(7, 6))
        hersheywPath.addLineToPoint(CGPointMake(7, 8))
        hersheywPath.addLineToPoint(CGPointMake(8, 9))
        hersheywPath.addLineToPoint(CGPointMake(10, 9))
        hersheywPath.addLineToPoint(CGPointMake(12, 8))
        hersheywPath.addLineToPoint(CGPointMake(14, 6))
        hersheywPath.addLineToPoint(CGPointMake(15, 3))
        hersheywPath.addLineToPoint(CGPointMake(15, 0))
        hersheywPath.moveToPoint(CGPointMake(15, 0))
        hersheywPath.addLineToPoint(CGPointMake(16, 4))
        hersheywPath.addLineToPoint(CGPointMake(17, 5))
        hersheywPath.addLineToPoint(CGPointMake(19, 5))
        hersheywPath.addLineToPoint(CGPointMake(21, 4))
        hersheywPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheywPath.lineWidth = 1
        hersheywPath.stroke()
        
        
        //// hersheyx Drawing
        var hersheyxPath = UIBezierPath()
        hersheyxPath.moveToPoint(CGPointMake(0, 4))
        hersheyxPath.addLineToPoint(CGPointMake(2, 1))
        hersheyxPath.addLineToPoint(CGPointMake(4, 0))
        hersheyxPath.addLineToPoint(CGPointMake(6, 0))
        hersheyxPath.addLineToPoint(CGPointMake(7, 1))
        hersheyxPath.addLineToPoint(CGPointMake(7, 8))
        hersheyxPath.addLineToPoint(CGPointMake(8, 9))
        hersheyxPath.addLineToPoint(CGPointMake(11, 9))
        hersheyxPath.addLineToPoint(CGPointMake(14, 7))
        hersheyxPath.addLineToPoint(CGPointMake(16, 4))
        hersheyxPath.moveToPoint(CGPointMake(13, 1))
        hersheyxPath.addLineToPoint(CGPointMake(12, 0))
        hersheyxPath.addLineToPoint(CGPointMake(10, 0))
        hersheyxPath.addLineToPoint(CGPointMake(9, 1))
        hersheyxPath.addLineToPoint(CGPointMake(5, 8))
        hersheyxPath.addLineToPoint(CGPointMake(4, 9))
        hersheyxPath.addLineToPoint(CGPointMake(2, 9))
        hersheyxPath.addLineToPoint(CGPointMake(1, 8))
        hersheyxPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyxPath.lineWidth = 1
        hersheyxPath.stroke()
        
        
        //// hersheyy Drawing
        var hersheyyPath = UIBezierPath()
        hersheyyPath.moveToPoint(CGPointMake(0, 4))
        hersheyyPath.addLineToPoint(CGPointMake(2, 0))
        hersheyyPath.addLineToPoint(CGPointMake(0, 6))
        hersheyyPath.addLineToPoint(CGPointMake(0, 8))
        hersheyyPath.addLineToPoint(CGPointMake(1, 9))
        hersheyyPath.addLineToPoint(CGPointMake(3, 9))
        hersheyyPath.addLineToPoint(CGPointMake(5, 8))
        hersheyyPath.addLineToPoint(CGPointMake(7, 6))
        hersheyyPath.addLineToPoint(CGPointMake(9, 3))
        hersheyyPath.moveToPoint(CGPointMake(10, 0))
        hersheyyPath.addLineToPoint(CGPointMake(4, 18))
        hersheyyPath.addLineToPoint(CGPointMake(3, 20))
        hersheyyPath.addLineToPoint(CGPointMake(1, 21))
        hersheyyPath.addLineToPoint(CGPointMake(0, 20))
        hersheyyPath.addLineToPoint(CGPointMake(0, 18))
        hersheyyPath.addLineToPoint(CGPointMake(1, 15))
        hersheyyPath.addLineToPoint(CGPointMake(4, 12))
        hersheyyPath.addLineToPoint(CGPointMake(7, 10))
        hersheyyPath.addLineToPoint(CGPointMake(9, 9))
        hersheyyPath.addLineToPoint(CGPointMake(12, 7))
        hersheyyPath.addLineToPoint(CGPointMake(15, 4))
        hersheyyPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyyPath.lineWidth = 1
        hersheyyPath.stroke()
        
        
        //// hersheyz Drawing
        var hersheyzPath = UIBezierPath()
        hersheyzPath.moveToPoint(CGPointMake(0, 4))
        hersheyzPath.addLineToPoint(CGPointMake(2, 1))
        hersheyzPath.addLineToPoint(CGPointMake(4, 0))
        hersheyzPath.addLineToPoint(CGPointMake(6, 0))
        hersheyzPath.addLineToPoint(CGPointMake(8, 2))
        hersheyzPath.addLineToPoint(CGPointMake(8, 4))
        hersheyzPath.addLineToPoint(CGPointMake(7, 6))
        hersheyzPath.addLineToPoint(CGPointMake(5, 8))
        hersheyzPath.addLineToPoint(CGPointMake(2, 9))
        hersheyzPath.addLineToPoint(CGPointMake(4, 10))
        hersheyzPath.addLineToPoint(CGPointMake(5, 12))
        hersheyzPath.addLineToPoint(CGPointMake(5, 15))
        hersheyzPath.addLineToPoint(CGPointMake(4, 18))
        hersheyzPath.addLineToPoint(CGPointMake(3, 20))
        hersheyzPath.addLineToPoint(CGPointMake(1, 21))
        hersheyzPath.addLineToPoint(CGPointMake(0, 20))
        hersheyzPath.addLineToPoint(CGPointMake(0, 18))
        hersheyzPath.addLineToPoint(CGPointMake(1, 15))
        hersheyzPath.addLineToPoint(CGPointMake(4, 12))
        hersheyzPath.addLineToPoint(CGPointMake(7, 10))
        hersheyzPath.addLineToPoint(CGPointMake(11, 7))
        hersheyzPath.addLineToPoint(CGPointMake(14, 4))
        hersheyzPath.miterLimit = 4;
        
        UIColor.blackColor().setStroke()
        hersheyzPath.lineWidth = 1
        hersheyzPath.stroke()
        
        hersheyDictionary = ["a":hersheyaPath, "b":hersheybPath, "c":hersheycPath, "d":hersheydPath, "e":hersheyePath, "f":hersheyfPath, "g":hersheygPath, "h":hersheyhPath, "i":hersheyiPath, "j":hersheyjPath, "k":hersheykPath, "l":hersheylPath, "m":hersheymPath, "n":hersheynPath, "o":hersheyoPath, "p":hersheypPath, "q":hersheyqPath, "r":hersheyrPath, "s":hersheysPath, "t":hersheytPath, "u":hersheyuPath, "v":hersheyvPath, "w":hersheywPath, "x":hersheyxPath, "y":hersheyyPath, "z":hersheyzPath
        ]
        
        hersheyArray = [ hersheyaPath, hersheybPath, hersheycPath, hersheydPath, hersheyePath, hersheyfPath, hersheygPath, hersheyhPath, hersheyiPath, hersheyjPath, hersheykPath, hersheylPath, hersheymPath, hersheynPath, hersheyoPath, hersheypPath, hersheyqPath, hersheyrPath, hersheysPath, hersheytPath, hersheyuPath, hersheyvPath, hersheywPath, hersheyxPath, hersheyyPath, hersheyzPath ]
        
        hersheyOffset = ["a":12.0, "b":0.0, "c":12.0, "d":0.0, "e":12.0, "f":0.0, "g":12.0, "h":0.0, "i":7.0, "j":7.0, "k":0.0, "l":0.0, "m":12.0, "n":12.0, "o":12.0, "p":11.0, "q":12.0, "r":11.0, "s":11.0, "t":0.0, "u":12.0, "v":12.0, "w":12.0, "x":12.0, "y":12.0, "z":12.0
        ]

        drawLetter()
    }
    
    func drawLetter() {
        
        let word = "california"
        let wordArray = Array(word.characters)
        let wordPath = UIBezierPath()
        //let wordLayer = CAShapeLayer()
        var wordOffset : CGFloat = 0
        
        switch wordArray[0]{
        case "f":
            wordOffset = wordOffset + 5.0
        case "j":
            wordOffset = wordOffset + 8.0
        case "p":
            wordOffset = wordOffset + 4.0
        default:
            break
        }
        
        for letter in wordArray {
            
            let yOffset = hersheyOffset[String(letter)]
            print(yOffset)
            let letterPath = getPathForLetter(String(letter))
            //print("letterpath \(letterPath)")
            
            switch letter {
            case "f":
                xOffset = xOffset - 5.0
            case "j":
                xOffset = xOffset - 8.0
            case "p":
                xOffset = xOffset - 4.0
            default:
                break
            }
            
            
            let actualPathRect = CGPathGetBoundingBox(letterPath.CGPath)
            //print(actualPathRect)
            let transform = CGAffineTransformMakeTranslation(xOffset,yOffset!)
            //print(transform)
            letterPath.applyTransform(transform)
            wordPath.appendPath(letterPath)
            let unTransform = CGAffineTransformMakeTranslation(-(xOffset), -(yOffset!))
            letterPath.applyTransform(unTransform)
            //print(letterPath)
            xOffset = xOffset + CGRectGetWidth(actualPathRect)
            
            
        }
        //        let transform = CGAffineTransformMakeTranslation(100.0,100.0)
        //        wordPath.applyTransform(transform)
        let wordTransform = CGAffineTransformMakeTranslation(wordOffset, 0.0)
        wordPath.applyTransform(wordTransform)
        wordView.frame = CGPathGetBoundingBox(wordPath.CGPath)
        wordView.center = CGPoint(x:view.center.x,
            y:view.center.y)
        wordView.backgroundColor = UIColor.cyanColor()
        view.addSubview(wordView)
        let transformScale = CGAffineTransformMakeScale(3.0, 3.0)
        wordView.transform = transformScale
        //        let transformTranslate = CGAffineTransformMakeTranslation(100, 200)
        //        wordView.transform = transformTranslate
        
        wordLayer.strokeColor = UIColor.blackColor().CGColor
        wordLayer.lineWidth = 1.0
        wordLayer.fillColor = UIColor.clearColor().CGColor
        wordLayer.path = wordPath.CGPath
        wordView.layer.addSublayer(wordLayer)
        
        let animateWord = CABasicAnimation(keyPath: "strokeEnd")
        animateWord.duration = 1.0
        animateWord.fromValue = 0.0
        animateWord.toValue = 1.0
        
        wordLayer.addAnimation(animateWord, forKey: "animate")
        wordLayer.speed = 0.0
        
//        animation.keyPath = "strokeEnd"
//        animation.values = [0, 1, 0]
//        animation.keyTimes = [0, 0.5, 1]
//        animation.duration = 6.0
//        //animation.additive = true
//        
//        wordLayer.addAnimation(animation, forKey: "animation")
        
        
        setupPan()
        setupPinch()
        setupRotate()
        setupTap()
    }
    
    func sliderValueDidChange(sender:FlowMoSlider!)
    {
        let sliderValue = (sender.value / 100)
        let timeInterval = CFTimeInterval(sliderValue)
        wordLayer.timeOffset = timeInterval
        print ("value--\(timeInterval)")
    }
    
    func setupTap() {
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        tap.delegate = self
        wordView.addGestureRecognizer(tap)
    }
    
    func setupPan() {
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        pan.delegate = self
        wordView.addGestureRecognizer(pan)
    }
    
    func setupPinch() {
        let pinch = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
        pinch.delegate = self
        wordView.addGestureRecognizer(pinch)
    }
    
    func setupRotate() {
        let rotate = UIRotationGestureRecognizer(target: self, action: "handleRotation:")
        rotate.delegate = self
        wordView.addGestureRecognizer(rotate)
    }
    
    func handleTap (sender: UITapGestureRecognizer) {
        print("tap")
        wordView.backgroundColor = RandomFlatColor()
    }
    
    func handlePan (sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.view)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPointZero, inView: self.view)
        
        if sender.state == UIGestureRecognizerState.Ended {
            // 1
            let velocity = sender.velocityInView(self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
            
            // 2
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            // 3
            var finalPoint = CGPoint(x:sender.view!.center.x + (velocity.x * slideFactor),
                y:sender.view!.center.y + (velocity.y * slideFactor))
            // 4
            finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
            finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
            
            // 5
            UIView.animateWithDuration(Double(slideFactor * 2),
                delay: 0,
                // 6
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: {sender.view!.center = finalPoint },
                completion: nil)
        }
    }
    
    func handlePinch(sender : UIPinchGestureRecognizer) {
        if let view = sender.view {
            view.transform = CGAffineTransformScale(view.transform,
                sender.scale, sender.scale)
            sender.scale = 1
        }
    }
    
    func handleRotation(sender: UIRotationGestureRecognizer) {
        if let view = sender.view {
            view.transform = CGAffineTransformRotate(view.transform, sender.rotation)
            sender.rotation = 0
        }
    }
    
    func getPathForLetter(letter: String) -> UIBezierPath {
        let path = hersheyDictionary[letter]
        
        return path!
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
