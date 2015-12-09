//
//  FlowMoController.swift
//  FlowMoSwift
//
//  Created by Conor Carey on 12/8/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import CoreMedia

class FlowMoController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    // define capture session
    let captureSession = AVCaptureSession()
    // define device output
    var videoFileOutput : AVCaptureMovieFileOutput?
    // var to denote recording status
    var isRecording = false

    func capture {  //cont
    //if we are not currently recording
        if !isRecording {
        // set recording bool to true
            isRecording = true
            print ("start recording")
            let outputPath = NSTemporaryDirectory() + "output.mov"
            let outputFileURL = NSURL(fileURLWithPath: outputPath)
            videoFileOutput?.startRecordingToOutputFileURL(outputFileURL, recordingDelegate: self)
    }   else {
            isRecording = false
            videoFileOutput?.stopRecording()
            print ("stop recording")
    }
}
    
    //cont
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        if error != nil {
            print(error)
            return
        }
        let urlString = outputFileURL.absoluteString
        UISaveVideoAtPathToSavedPhotosAlbum(urlString, nil, nil, nil)
        generateImageSequence(outputFileURL)
    }
    
    //cont
    func generateImageSequence(outputFileURL: NSURL) {
        let avURLAsset = AVURLAsset(URL: outputFileURL, options:nil)
        
        let imageGenerator = AVAssetImageGenerator.init(asset: avURLAsset)
        imageGenerator.requestedTimeToleranceAfter=kCMTimeZero
        imageGenerator.requestedTimeToleranceBefore=kCMTimeZero
        
        var imageHashRate: [NSValue] = []
        var loopDuration = avURLAsset.duration.value
        let timeValue = Float(CMTimeGetSeconds(avURLAsset.duration))
        print (loopDuration)
        
        for var t = 0; t < 1800; t + 20 {
            var cmTime = CMTimeMake(Int64(t), avURLAsset.duration.timescale)
            var timeValue = NSValue(CMTime: cmTime)
            imageHashRate.append(timeValue)
        }
    }
}