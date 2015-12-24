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
    var flowMoArray : [UIImage] = []
    var flowMoDisplaySlider:FlowMoSlider?
    //let flowMoAudio : NSURL
    let flowMoView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addFlowMoView()
        addFlowMoSlider()
        
    }
    
    func addFlowMoView() {
        flowMoView.contentMode = UIViewContentMode.ScaleAspectFill
        flowMoView.image = flowMoArray[0]
        self.view .addSubview(flowMoView)
    }
    
    func addFlowMoSlider() {
        flowMoDisplaySlider = FlowMoSlider(frame: self.view.bounds)
        flowMoDisplaySlider?.minimumValue = 0.0
        flowMoDisplaySlider?.maximumValue = 90.0//Float(flowMoArray.count - 1)
        flowMoDisplaySlider?.value = 0.0
        flowMoDisplaySlider?.continuous = true
        flowMoDisplaySlider!.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        self.view.addSubview(flowMoDisplaySlider!)
    }
    
    func sliderValueDidChange (sender: UISlider) {
        print ("value--\(sender.value)")
    }
}
