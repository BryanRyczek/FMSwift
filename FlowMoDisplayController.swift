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

class FlowMoDisplayController: UIViewController {
    var flowMoImageArray : [UIImage] = []
    var flowMoDisplaySlider:FlowMoSlider?
    var flowMoAudioFile : NSURL?
    let flowMoView = UIImageView()
    //define audio player
    let audioPlayer = FlowMoAudioPlayer()
    //
    var playbackTimer = NSTimer ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFlowMoSlider()
        addFlowMoView()
        print(self.flowMoImageArray.count)
        flowMoPlaybackTimer()
        
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
        self.view.addSubview(flowMoDisplaySlider!)
    }
    
    func sliderValueDidChange (sender: UISlider) {
        let currentImageIndex = Int((flowMoDisplaySlider?.value)!)
        let localImage = flowMoImageArray[currentImageIndex]
        print(currentImageIndex)
        flowMoView.image = localImage
    }
    
    func flowMoPlaybackTimer() {
        
        playbackTimer = NSTimer.scheduledTimerWithTimeInterval(0.033333, target:self, selector: "playFlowMoImageSequence", userInfo: nil, repeats: true)
    }
    
    func playFlowMoImageSequence() {
        flowMoDisplaySlider!.value = flowMoDisplaySlider!.value + 1
        sliderValueDidChange(flowMoDisplaySlider!)
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
