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

class FlowMo: UIViewController {
    //Audio file to be integrated with the FlowMo
    var flowMoAudio: NSURL = NSURL.init()
    //FlowMo image array, the meat of the project
    var flowMo: [UIImage] = []
    
//    func generateFlowMo (flowMoArray: [UIImage], audioObject: NSURL) -> [UIImage]
//    {
//        flowMo = flowMoArray
//        flowMoAudio = audioObject
//    }
    
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
    
    
}