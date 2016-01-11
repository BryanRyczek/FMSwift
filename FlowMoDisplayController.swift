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

class FlowMoDisplayController: FlowMo {
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
    var textfield = FlowMoTextField()
    //
    weak var playbackTimer : NSTimer?
    
    enum playbackState {
        case Playing
        case Paused
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flowMoAudioFile = getAudio()
        flowMoImageArray = getFlowMo()
        flowmoAudioCurrentTime = flowmoAudioStartTime
        addFlowMoSlider()
        addFlowMoView()
        togglePausePlay()
        setupDoubleTapGesture()
        setupUpSwipeGesture()
        textfield = FlowMoTextField.init(frame: CGRectMake(0, self.view.frame.size.width/2, self.view.frame.size.width, 50))
        textfield.backgroundColor = UIColor.whiteColor()
        textfield.alpha = 0.15
        let textFieldPan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        textfield.addGestureRecognizer(textFieldPan)
        self.view.addSubview(textfield)
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
    
    func sliderValueDidChange (sender: UISlider) {
        
        let currentImageIndex = Int((flowMoDisplaySlider?.value)!)
        let localImage = flowMoImageArray[currentImageIndex]
        flowMoView.image = localImage
        flowmoAudioCurrentTime = (Double(currentImageIndex) / 30.00000000000) + Double(flowmoAudioStartTime!)
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
    
//    func dismissFlowMoDisplayController (sender: AnyObject) {
//        audioPlayer.audioPlayer.stop()
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    //MARK: GESTURE METHODS
    
    func handlePan (recognizer:UIPanGestureRecognizer) {
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
