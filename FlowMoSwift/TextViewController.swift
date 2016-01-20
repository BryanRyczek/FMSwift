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

        
        hersheyOffset = ["a":12.0, "b":0.0, "c":12.0, "d":0.0, "e":12.0, "f":0.0, "g":12.0, "h":0.0, "i":7.0, "j":7.0, "k":0.0, "l":0.0, "m":12.0, "n":12.0, "o":12.0, "p":11.0, "q":12.0, "r":11.0, "s":11.0, "t":0.0, "u":12.0, "v":12.0, "w":12.0, "x":12.0, "y":12.0, "z":12.0
        ]

        drawLetter()
    }
    
    func drawLetter() {
        
        let word = "california"
        let wordArray = Array(word.characters)
        let wordPath = UIBezierPath()
        var wordOffset : CGFloat = 0
        
        switch wordArray[0]{
        case "f":
            wordOffset += 5.0
        case "j":
            wordOffset +=  8.0
        case "p":
            wordOffset += 4.0
        default:
            break
        }
        
        for letter in wordArray {
            
            let yOffset = hersheyOffset[String(letter)]
//            let bezPath = BezierObjects(fromLetter: String(letter))
//            print(BezierObjects.hersheyPath)
            let letterPath = UIBezierPath()
            
            switch letter {
            case "f":
                xOffset -= 5.0
            case "j":
                xOffset -= 8.0
            case "p":
                xOffset -= 4.0
            default:
                break
            }
            
            
            //print(actualPathRect)
            let transform = CGAffineTransformMakeTranslation(xOffset,yOffset!)
            let unTransform = CGAffineTransformMakeTranslation(-(xOffset), -(yOffset!))
            letterPath.applyTransform(transform)
            wordPath.appendPath(letterPath)
            letterPath.applyTransform(unTransform)
            //print(letterPath)
            let actualPathRect = CGPathGetBoundingBox(letterPath.CGPath)
            xOffset = xOffset + CGRectGetWidth(actualPathRect)
            
            
        }
        // need this transform to fit word in frame due to letter offsets
        let wordTransform = CGAffineTransformMakeTranslation(wordOffset, 0.0)
        wordPath.applyTransform(wordTransform)
        wordView.frame = CGPathGetBoundingBox(wordPath.CGPath)
        wordView.center = CGPoint(x:view.center.x,
            y:view.center.y)
        wordView.backgroundColor = UIColor.cyanColor()
        view.addSubview(wordView)
        let transformScale = CGAffineTransformMakeScale(3.0, 3.0)
        wordView.transform = transformScale
        
        if (letter == " ")
        {
            wordLayer.strokeColor = UIColor.clearColor().CGColor
            wordLayer.lineWidth = 2.0
            wordLayer.fillColor = UIColor.clearColor().CGColor
            wordLayer.path = wordPath.CGPath
            wordView.layer.addSublayer(wordLayer)
        }
        else
        {
            wordLayer.strokeColor = UIColor.blackColor().CGColor
            wordLayer.lineWidth = 2.0
            wordLayer.fillColor = UIColor.clearColor().CGColor
            wordLayer.path = wordPath.CGPath
            wordView.layer.addSublayer(wordLayer)
        }
        
        
        //ANIMATION
        let animateWord = CABasicAnimation(keyPath: "strokeEnd")
        animateWord.duration = 1.0
        animateWord.fromValue = 0.0
        animateWord.toValue = 1.0
        
        wordLayer.addAnimation(animateWord, forKey: "animate")
        wordLayer.speed = 0.0
        
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
        wordView.backgroundColor = GradientColor(UIGradientStyle.LeftToRight, frame: wordView.frame, colors: [FlatPurple(), wordView.backgroundColor!, FlatYellow(), FlatRed(), FlatPlum()])
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
