//
//  FlowMo.swift
//  FlowMoRefactored
//
//  Created by Conor Carey on 12/15/15.
//  Copyright © 2015 Conor Carey. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import CoreMedia

class FlowMo {
    
    var flowMoAudio: NSURL
    var flowMo: [UIImage]
    var flowMoAudioStartTime: NSTimeInterval
    var flowMoAudioDuration: NSTimeInterval
    
    init()
    {
        flowMoAudio = NSURL.init()
        flowMo = []
        flowMoAudioStartTime = 0
        flowMoAudioDuration  = 0
    }
    
//    func generateFlowMo (flowMoArray: [UIImage], audioObject: NSURL) -> [UIImage]
//    {
//        flowMo = flowMoArray
//        flowMoAudio = audioObject
//    }
    
    func setNewAudio(newAudio: NSURL)
    {
        flowMoAudio = newAudio
    }
    
    func setNewFlowMo(newFlowMo: [UIImage])
    {
        flowMo = newFlowMo
    }
    
    func setFlowMoAudioStartTime(startTime: NSTimeInterval) {
        flowMoAudioStartTime = startTime
    }
    
    func setFlowMoAudioDuration(duration: NSTimeInterval) {
        flowMoAudioDuration = duration
    }
    
    func getAudio() -> NSURL
    {
        return flowMoAudio
    }
    
    func getFlowMo() -> [UIImage]
    {
        if flowMo.isEmpty
        {
            print ("Is Empty")
            return flowMo
        }
        
        return flowMo
    }
    
    func getFlowMoAudioStartTime() -> NSTimeInterval {
        return flowMoAudioStartTime
    }

    func getFlowMoAudioDuration() -> NSTimeInterval {
        return flowMoAudioDuration
    }
    
    class var SingletonModel: FlowMo {
        
        struct Singleton
        {
            static let model = FlowMo()
        }
        
        return Singleton.model
    }
}