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
    // define video output
    var videoFileOutput : AVCaptureMovieFileOutput?
    //defint audio output
    var audioFileOutput : AVCaptureAudioDataOutput?
    // var to denote recording status
    var isRecording = false
    

    func capture (sender: UILongPressGestureRecognizer) {  //cont
    //if we are not currently recording
        if (sender.state == UIGestureRecognizerState.Ended){
            isRecording = false
            videoFileOutput?.stopRecording()
            //fireTorch()
            print ("stop recording")
            }
        else if (sender.state == UIGestureRecognizerState.Began){
            isRecording = true
            captureAnimationBar()
            print ("start recording")
            let outputPath = NSTemporaryDirectory() + "output.mov"
            let outputFileURL = NSURL(fileURLWithPath: outputPath)
            videoFileOutput?.startRecordingToOutputFileURL(outputFileURL, recordingDelegate: self)
            }}
    
    func captureAnimationBar() {
        let coloredSquare = UIView()
        coloredSquare.backgroundColor = UIColor.blueColor()
        coloredSquare.frame = CGRect(x: 0, y: 0, width: 0, height: 20)
        self.view.addSubview(coloredSquare)
        
        UIView.animateWithDuration(3.0, animations: {
            coloredSquare.backgroundColor = UIColor.blueColor()
            coloredSquare.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20)
            } , completion: { finished in
                print("finished")
        })
        
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
        //NEED TO PLUG THESE VALUES INTO THE BELOW LOOP TO GENERATE imageHashRateArray ONCE FURTHER WORK DONE
        var loopDuration = avURLAsset.duration.value
        let timeValue = Float(CMTimeGetSeconds(avURLAsset.duration))
        
        for var t = 0; t < 1800; t += 20 {
            let cmTime = CMTimeMake(Int64(t), avURLAsset.duration.timescale)
            let timeValue = NSValue(CMTime: cmTime)
            imageHashRate.append(timeValue)
            }
        
        var flowMoImageArray: [UIImage] = []
        imageGenerator.generateCGImagesAsynchronouslyForTimes(imageHashRate) {(requestedTime, image, actualTime, result, error) -> Void in
            if (result == .Succeeded) {
                flowMoImageArray.append(UIImage(CGImage: image!))
            }
            if (result == .Failed) {
                
            }
            if (result == .Cancelled) {
                
            }
        }
    }
        
}
