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
    
    init()
    {
        flowMoAudio = NSURL.init()
        flowMo = []
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
    
    func createRealFlowMo(flowMoArray: [UIImage], audio: NSURL)
    {
        
    }
    
    class var SingletonModel: FlowMo {
        
        struct Singleton
        {
            static let model = FlowMo()
        }
        
        return Singleton.model
    }
}