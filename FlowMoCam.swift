//
//  FlowMoCam.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/7/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreMedia

class FlowMoCam: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    
    // define capture session
    let captureSession = AVCaptureSession()
    // define device output
    var videoFileOutput : AVCaptureMovieFileOutput?
    // var to denote recording status
    var isRecording = false
    
    
    override func viewDidLoad() {
        print("1")
        super.viewDidLoad()
        //set camera to highest resolution device will support
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        // create array of available devices (front camera, back camera, microphone)
        var currentDevice:AVCaptureDevice?
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for device in devices {
            if device.position == AVCaptureDevicePosition.Back {
                currentDevice = device
            }
        }
        
        let captureDeviceInput:AVCaptureDeviceInput
        do {
            captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice)
        } catch {
            print(error)
            return
        }
        
        //create instance used to save data for movie file
        videoFileOutput = AVCaptureMovieFileOutput()
        videoFileOutput?.maxRecordedDuration
        
        //Assign the input and output devices to the capture session
        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(videoFileOutput)
        
        //instance variable with the p
        var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
        
        //camera preview layer
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        captureSession.startRunning()
        captureButton()
        
    }
    
    func capture(sender: AnyObject) {
        //if we are not currently recording
        if !isRecording {
            // set recording bool to true
            isRecording = true
            print ("start recording")
            let outputPath = NSTemporaryDirectory() + "output.mov"
            let outputFileURL = NSURL(fileURLWithPath: outputPath)
            videoFileOutput?.startRecordingToOutputFileURL(outputFileURL, recordingDelegate: self)
        } else {
            isRecording = false
            videoFileOutput?.stopRecording()
            print ("stop recording")
        }
    }
    
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        if error != nil {
            print(error)
            return
        }
        let urlString = outputFileURL.absoluteString
        UISaveVideoAtPathToSavedPhotosAlbum(urlString, nil, nil, nil)
        generateImageSequence(outputFileURL)
    }
    
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
    

    func captureButton() {
        let captureButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        captureButton.frame = CGRectMake((self.view.frame.width/2)-35, (self.view.frame.height)-105, 70, 70)
        captureButton.backgroundColor = UIColor.whiteColor()
        captureButton.addTarget(self, action: "capture:", forControlEvents: .TouchUpInside)
        self.view.addSubview(captureButton)
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
