//
//  FlowMoDisplayController.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/24/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import CoreMedia
import CoreImage
import Photos
import Chameleon

class FlowMoDisplayController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    var flowMoImageArray : [UIImage] = []
    var flowMoDisplaySlider:FlowMoSlider?
    var flowMoAudioFile : NSURL?
    var flowmoAudioStartTime: NSTimeInterval?
    var flowmoAudioCurrentTime: NSTimeInterval?
    var flowmoAudioDuration: NSTimeInterval?
    let flowMoView = UIImageView()
    var currentPlaybackState = playbackState.Paused
    //define audio player
    let audioPlayer = FlowMoAudioRecorderPlayer()
    var textField = UITextField()
    var wordView : UIView?
    var wordLayer = CAShapeLayer()
    weak var playbackTimer : NSTimer?
    
    enum playbackState {
        case Playing
        case Paused
    }
    
    enum scratchModeState {
        case Stopped
        case Recording
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flowMoAudioFile = FlowMoController().model.getAudio()
        print(flowMoAudioFile)
        flowMoImageArray = FlowMoController().model.getFlowMo()
        flowmoAudioStartTime = FlowMoController().model.getFlowMoAudioStartTime()
        
        flowmoAudioCurrentTime = flowmoAudioStartTime
        addFlowMoSlider()
        addFlowMoView()
        togglePausePlay()
        setupDoubleTapGesture()
        setupUpSwipeGesture()
        textField = FlowMoTextField.init(frame: CGRectMake(0, self.view.frame.size.width/2, self.view.frame.size.width, 50))
        textField.backgroundColor = UIColor.whiteColor()
        textField.alpha = 0.15
        let textFieldPan = UIPanGestureRecognizer(target: self, action: "handleTextPan:")
        textField.addGestureRecognizer(textFieldPan)
        self.view.addSubview(textField)
        textField.delegate = self
    }
    
    func addFlowMoView() {
        flowMoView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        flowMoView.contentMode = UIViewContentMode.ScaleAspectFill
        flowMoView.image = flowMoImageArray[0]
        flowMoView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(flowMoView)
    }
    
    func addFlowMoSlider() {
        flowMoDisplaySlider = FlowMoSlider(frame: self.view.bounds)
        flowMoDisplaySlider?.minimumValue = 0.0
        flowMoDisplaySlider?.maximumValue = Float(flowMoImageArray.count - 1)
        flowMoDisplaySlider?.value = 0.0
        flowMoDisplaySlider?.continuous = true
        flowMoDisplaySlider!.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        flowMoDisplaySlider!.addTarget(self, action: "sliderTouchReleased:", forControlEvents: .TouchUpInside)
        flowMoDisplaySlider!.addTarget(self, action: "sliderTouchDown:", forControlEvents: .TouchDown)
        self.view.addSubview(flowMoDisplaySlider!)
    }
    
    func sliderTouchDown (sender: UISlider) {
        if (currentPlaybackState == .Playing) {
            audioPlayer.audioPlayer.pause()
            playbackTimer?.invalidate()
        }
    }
    
    func sliderTouchReleased (sender: UISlider) {
        if (currentPlaybackState == .Playing) {
            audioPlayback(flowmoAudioCurrentTime!)
            flowMoPlaybackTimer()
        }
    }
    
    func drawCursive(string: String?) -> UIBezierPath {
        
        let wordArray = Array(string!.characters)
        var wordOffset : CGFloat = 0
        
        switch wordArray[0] {
        case "f":
            wordOffset += 5.0
        case "j":
            wordOffset += 8.0
        case "p":
            wordOffset += 4.0
        default:
            break
        }
        
        let wordPath = TextViewController().cursivePathFromString(string!)
        
        let wordTransform = CGAffineTransformMakeTranslation(wordOffset, 0.0)
        wordPath.applyTransform(wordTransform)
        
        return wordPath
            
        }
    
    
    func bezPathIntoLayer () -> CAShapeLayer {
        
        let wordLayer = CAShapeLayer()
        wordLayer.strokeColor = UIColor.whiteColor().CGColor
        wordLayer.lineWidth = 2.0
        wordLayer.fillColor = UIColor.clearColor().CGColor
        return wordLayer
        
        }
        
    func layerIntoView (bezierPath : UIBezierPath, shapeLayer :CAShapeLayer) -> UIView {
        
        
        //ANIMATION
        let animateWord = CABasicAnimation(keyPath: "strokeEnd")
        animateWord.duration = 1.0
        animateWord.fromValue = 0.0
        animateWord.toValue = 1.0
        animateWord.fillMode = kCAFillModeBoth
    
        wordLayer = shapeLayer
        wordLayer.addAnimation(animateWord, forKey: "animate")
        wordLayer.speed = 0.0
        wordLayer.path = bezierPath.CGPath
        wordLayer.timeOffset = 0
        wordLayer.strokeEnd = 1
        let wordView = UIView()
        wordView.frame = CGPathGetBoundingBox(bezierPath.CGPath)
        wordView.center = CGPoint(x:view.center.x,
            y:view.center.y)
        wordView.backgroundColor = UIColor.clearColor()
        wordView.alpha = 0.5
        let transformScale = CGAffineTransformMakeScale(3.0, 3.0)
        wordView.transform = transformScale
        wordView.layer.addSublayer(shapeLayer)
        return wordView
        
        }
    
    func sliderValueDidChange (sender: UISlider) {
        
        let currentImageIndex = Int((flowMoDisplaySlider?.value)!)
        let localImage = flowMoImageArray[currentImageIndex]
        flowMoView.image = localImage
        flowmoAudioCurrentTime = (Double(currentImageIndex) / 30.00) + Double(flowmoAudioStartTime!)
        
        let sliderValue = (sender.value / flowMoDisplaySlider!.maximumValue)
        //print("sliderValue \(sliderValue)")
        let timeInterval = CFTimeInterval(sliderValue)
        //print("timeInterval \(timeInterval)")
        wordLayer.timeOffset = timeInterval
        //print("timeOffset \(wordLayer.timeOffset)")
    }
    
    func flowMoPlaybackTimer() {
        
        playbackTimer = NSTimer.scheduledTimerWithTimeInterval(0.0333333333333333, target:self, selector: "playFlowMoImageSequence", userInfo: nil, repeats: true)
    }
    
    func audioPlayback(time: NSTimeInterval) {
        audioPlayer.playAudio(flowMoAudioFile!, startTime: time)
    }
    
    func playFlowMoImageSequence() {
        if (Int(flowMoDisplaySlider!.value) == flowMoImageArray.count-1) {
            flowMoDisplaySlider!.value = 0
            audioPlayer.audioPlayer.pause()
            audioPlayback(flowmoAudioStartTime!)
            sliderValueDidChange(flowMoDisplaySlider!)
        } else {
            flowMoDisplaySlider!.value = flowMoDisplaySlider!.value + 1
            sliderValueDidChange(flowMoDisplaySlider!)
        }
    }
    
    func togglePausePlay() {
        if (currentPlaybackState == .Paused) {
            flowMoPlaybackTimer()
            audioPlayback(flowmoAudioCurrentTime!)
            currentPlaybackState = .Playing
        } else if (currentPlaybackState == .Playing) {
            playbackTimer?.invalidate()
            audioPlayer.audioPlayer.pause()
            flowmoAudioCurrentTime = audioPlayer.audioPlayer.currentTime
            currentPlaybackState  = .Paused
        }
    }
    
    func pauseFlomo () {
        if (currentPlaybackState == .Playing) {
            playbackTimer?.invalidate()
            audioPlayer.audioPlayer.pause()
            flowmoAudioCurrentTime = audioPlayer.audioPlayer.currentTime
            currentPlaybackState  = .Paused
        }
    }
    
    func dismissFlowMoDisplayController (sender: AnyObject) {
        audioPlayer.audioPlayer.stop()
        playbackTimer?.invalidate()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: GESTURE METHODS
    
    func handleTextPan (recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x,
                y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func setupUpSwipeGesture() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: "dismissFlowMoDisplayController:")
        upSwipe.direction = .Up
        upSwipe.delaysTouchesBegan = true
        view.addGestureRecognizer(upSwipe)
    }
    
    func setupDoubleTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: "togglePausePlay")
        tap.numberOfTapsRequired = 2
        tap.delaysTouchesBegan = true
        view.addGestureRecognizer(tap)
    }
    //MARK: DRAW CURSIVE TEXT
    
    
    func handleTap (sender: UITapGestureRecognizer) {
        print("tap")
        wordLayer.strokeColor = RandomFlatColorWithShade(.Light).CGColor
       // wordView.backgroundColor = GradientColor(UIGradientStyle.LeftToRight, frame: wordView.frame, colors: [FlatPurple(), wordView.backgroundColor!, FlatYellow(), FlatRed(), FlatPlum()])
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
    
    func setupTap(view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    func setupPan(view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        pan.delegate = self
        view.addGestureRecognizer(pan)
    }
    
    func setupPinch(view: UIView) {
        let pinch = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
        pinch.delegate = self
        view.addGestureRecognizer(pinch)
    }
    
    func setupRotate(view: UIView) {
        let rotate = UIRotationGestureRecognizer(target: self, action: "handleRotation:")
        rotate.delegate = self
        view.addGestureRecognizer(rotate)
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
    //MARK: Text view delegate methods
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let textFieldString = textField.text
        print(textFieldString)
        textField.removeFromSuperview()
        
        pauseFlomo()
        
        if let slider = flowMoDisplaySlider {
        slider.value = 0
        flowmoAudioCurrentTime = Double(flowmoAudioStartTime!)
        }
        print(flowmoAudioCurrentTime)
        if let string = textFieldString {
        wordView = layerIntoView(drawCursive(string), shapeLayer: bezPathIntoLayer())
        }
        
        if let wordyView = wordView {
        view.addSubview(wordyView)
        
        setupPan(wordyView)
        setupPinch(wordyView)
        setupRotate(wordyView)
        setupTap(wordyView)
        
        }
        togglePausePlay()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
            }
    
    //MARK: HELPER METHODS
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
