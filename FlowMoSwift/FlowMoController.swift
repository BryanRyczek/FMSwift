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
import CoreImage
import Photos


class FlowMoController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    // MARK: GLOBAL VARS
    // define capture session
    let captureSession = AVCaptureSession()
    // define video input devices
    var backFacingCamera:AVCaptureDevice?
    var frontFacingCamera:AVCaptureDevice?
    var currentDevice:AVCaptureDevice?
    // define audio input device
    var audioDevice : AVCaptureDevice?
    // define audio output
    var audioFileOutput : AVCaptureAudioDataOutput?
    // var to denote recording status
    var isRecording = false
    // Define state of torch. 0 = off, 1 = on
    var torchState = 0
    // define video output
    var videoFileOutput : AVCaptureMovieFileOutput?
    //define audio recorder
    let audioRecorder = FlowMoAudioRecorder()
    let audioPlayer = FlowMoAudioPlayer()
    
    //define device screen brightness
    var screenBrightness : CGFloat?
    let flashLayer = CALayer()
    var flowMoImageArray: [UIImage] = []
    
    //MARK: METHODS
    //MARK: CAMERA METHODS
    
    func loadCamera(){
        //set camera to highest resolution device will support
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        // create array of available devices (front camera, back camera, microphone)
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for device in devices {
            if device.position == AVCaptureDevicePosition.Back {
                backFacingCamera = device
            } else if device.position == AVCaptureDevicePosition.Front {
                frontFacingCamera = device
            }
        }
        currentDevice = backFacingCamera
        
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
        
        //create instance used to save audio data
        
//        let audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
//        
//        let audioInput:AVCaptureDeviceInput
//        do {
//            audioInput = try AVCaptureDeviceInput(device:audioDevice)
//        } catch {
//            print(error)
//            return
//        }
//        
//        audioFileOutput = AVCaptureAudioDataOutput()
        
        //Assign the input and output devices to the capture session
        captureSession.addInput(captureDeviceInput)
        //captureSession.addInput(audioInput)
        captureSession.addOutput(videoFileOutput)
        //captureSession.addOutput(audioFileOutput)
        
    }
    
    func toggleCamera (sender: AnyObject) {
        captureSession.beginConfiguration()
        
        // Change the device based on the current camera
        let newDevice = (currentDevice?.position == AVCaptureDevicePosition.Front) ?
            backFacingCamera : frontFacingCamera
        
        // Remove all inputs from the session
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        // Change to the new input
        let cameraInput:AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice)
        } catch {
            print(error)
            return
        }
        
    if captureSession.canAddInput(cameraInput) {
       captureSession.addInput(cameraInput)
        }
        currentDevice = newDevice
        captureSession.commitConfiguration()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var touchPoint = touches.first as UITouch!
        var screenSize = self.view.bounds.size
        var focusPoint = touchPoint.locationInView(self.view)
        print(touchPoint)
        //var focusPoint = CGPoint(x: touchPoint.locationInView(self.view).y / screenSize.height, y: 1.0 - touchPoint.locationInView(self.view.x / screenSize.width)

        if let device = currentDevice {
            do {
                try device.lockForConfiguration()
            } catch {
                print(error)
                return
            }
            
            if device.focusPointOfInterestSupported {
                print("focus supported")
                device.focusPointOfInterest = focusPoint
                device.focusMode = AVCaptureFocusMode.AutoFocus
            }
            if device.exposurePointOfInterestSupported {
                 print("exposure supported")
                device.exposurePointOfInterest = focusPoint
                device.exposureMode = AVCaptureExposureMode.AutoExpose
                }
            device.unlockForConfiguration()
        }
    }

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
    
    func capture (sender: UILongPressGestureRecognizer) {
        //cont
        //if we are not currently recording
        if (sender.state == UIGestureRecognizerState.Ended){
            isRecording = false
            audioRecorder.recordToggle()
            fireTorch(sender)
            if (torchState == 1 && currentDevice?.position == AVCaptureDevicePosition.Front) {
                flashLayer.removeFromSuperlayer()
                UIScreen.mainScreen().brightness = screenBrightness!
            }
            audioPlayer.playAudio(audioRecorder.recordedAudioURL!)
            print ("stop recording")
            videoFileOutput?.stopRecording()
        }
        else if (sender.state == UIGestureRecognizerState.Began){
            isRecording = true
            audioRecorder.recordToggle()
            captureAnimationBar()
            frontFlash()
            print ("start recording")
            fireTorch(sender)
            let outputPath = NSTemporaryDirectory() + "output.mov"
            let outputFileURL = NSURL(fileURLWithPath: outputPath)
            videoFileOutput?.startRecordingToOutputFileURL(outputFileURL, recordingDelegate: self)
        }
    }
    
// MARK: FLASH METHODS
    
    func fireTorch(sender: AnyObject) {
        print("Called", currentDevice!)
        if (currentDevice!.hasTorch && torchState==1) {
            do {
                print("Torch mode is working")
                try currentDevice!.lockForConfiguration()
                if (currentDevice!.torchMode == AVCaptureTorchMode.On) {
                    currentDevice!.torchMode = AVCaptureTorchMode.Off
                } else {
                    do {
                        try currentDevice!.setTorchModeOnWithLevel(1.0)
                    } catch {
                        print(error)
                    }
                }
                currentDevice!.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    func setTorchMode(sender: AnyObject) {
        if (torchState == 0)
        {
            torchState++
            print(torchState, "has changed")
        }
        else
        {
            torchState = 0
        }
    }
    
    func frontFlash(){
        if (torchState == 1 && currentDevice?.position == AVCaptureDevicePosition.Front) {
            
            screenBrightness = UIScreen.mainScreen().brightness
            UIScreen.mainScreen().brightness = CGFloat(1.0)
            flashLayer.backgroundColor = UIColor.whiteColor().CGColor
            flashLayer.opacity = 0.85
            flashLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            self.view.layer.addSublayer(flashLayer)
        }
    }
    
   // MARK: FILE PROCESSING METHODS
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        if error != nil {
            print(error)
            return
        }
        let urlString = outputFileURL.absoluteString
        //saveVideoToCameraRoll(outputFileURL)
        generateImageSequence(outputFileURL)
    }
    
    func saveVideoToCameraRoll(outputFileURL: NSURL!) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(outputFileURL)
            }, completionHandler: { success, error in
                if !success { NSLog("Failed to create video: %@", error!) }
        })
    }
    
    
    func generateImageSequence(outputFileURL: NSURL) {
        let avURLAsset = AVURLAsset(URL: outputFileURL, options:nil)
        
        let imageGenerator = AVAssetImageGenerator.init(asset: avURLAsset)
        imageGenerator.requestedTimeToleranceAfter=kCMTimeZero
        imageGenerator.requestedTimeToleranceBefore=kCMTimeZero
        
        var imageHashRate1 = [NSValue]()
        var imageHashRate2 = [NSValue]()
        var imageHashRate3 = [NSValue]()
        var imageHashRate4 = [NSValue]()
        var imageHashRate5 = [NSValue]()
        var imageHashRate6 = [NSValue]()
        var imageHashRate7 = [NSValue]()
        var imageHashRate8 = [NSValue]()
        var imageHashRate9 = [NSValue]()
        let videoDuration = avURLAsset.duration
        //These floats are calculated to be fed into the below for loop, which generates image hashing times
        let videoDurationFloat = Float(videoDuration.value)
        var flowmoDurationFloat : Float = 1800 // Define length of flomo to be processed based on a timescale of 600 where (600 = 1 second)
        var flowmoStartTimeFloat = videoDurationFloat - flowmoDurationFloat
        // In case of short video, generate proper values to feed into loop
        if (flowmoStartTimeFloat <= 0) {
            flowmoDurationFloat = flowmoDurationFloat + flowmoStartTimeFloat
            flowmoStartTimeFloat = 0
        }
       
        for var t = flowmoStartTimeFloat; t < flowmoStartTimeFloat + flowmoDurationFloat; t += 20 {
            let cmTime = CMTimeMake(Int64(t), avURLAsset.duration.timescale)
            let timeValue = NSValue(CMTime: cmTime)
            switch (imageHashRate9.count  != 10)
            {
            case imageHashRate1.count <= 10:
                imageHashRate1.append(timeValue)
            case imageHashRate1.count == 10 && imageHashRate2.count <= 10:
                imageHashRate2.append(timeValue)
            case imageHashRate2.count == 10 && imageHashRate3.count <= 10:
                imageHashRate3.append(timeValue)
            case imageHashRate3.count == 10 && imageHashRate4.count <= 10:
                imageHashRate4.append(timeValue)
            case imageHashRate4.count == 10 && imageHashRate5.count <= 10:
                imageHashRate5.append(timeValue)
            case imageHashRate5.count == 10 && imageHashRate6.count <= 10:
                imageHashRate6.append(timeValue)
            case imageHashRate6.count == 10 && imageHashRate7.count <= 10:
                imageHashRate7.append(timeValue)
            case imageHashRate7.count == 10 && imageHashRate8.count <= 10:
                imageHashRate8.append(timeValue)
            case imageHashRate8.count == 10 && imageHashRate9.count <= 10:
                imageHashRate9.append(timeValue)
            default:
                return
            }
            
            }
        print("hi")
        print(imageHashRate9.count)
        //FIXME: We need a better method which will take [imageHashRate] and allocate its contents to a series of arrays, which will then be sent to individual dispatch threads to process. This is a process to test for speeding up of the image processing. I picked arrays with a count of 10 because in testing the image processing seems to become much less stable after the 10th image processed.
        
//          //define number of arrays needed
//        let dispatchArrayCount = Int(ceil(CGFloat(imageHashRate.count) / 10.00))
//        
//            //slice arrays. notice that slicing produces type: ArraySlice<NSValue>
//        let testArray = imageHashRate[0..<9]
//        let testArray2 = imageHashRate[10..<19]
//        let testArray3 = imageHashRate[20..<29]
//        let testArray4 = imageHashRate[30..<39]
//        let testArray5 = imageHashRate[40..<49]
//        let testArray6 = imageHashRate[50..<59]
//        let testArray7 = imageHashRate[60..<69]
//        let testArray8 = imageHashRate[70..<79]
//        let testArray9 = imageHashRate[80..<89]
        var conglomorateArray = [NSValue]()
        conglomorateArray.appendContentsOf(imageHashRate1)
        conglomorateArray.appendContentsOf(imageHashRate2)
        conglomorateArray.appendContentsOf(imageHashRate3)
        conglomorateArray.appendContentsOf(imageHashRate4)
        conglomorateArray.appendContentsOf(imageHashRate5)
        conglomorateArray.appendContentsOf(imageHashRate6)
        conglomorateArray.appendContentsOf(imageHashRate7)
        conglomorateArray.appendContentsOf(imageHashRate8)
        conglomorateArray.appendContentsOf(imageHashRate9)
        
        print (conglomorateArray)
//        for var n = 0; n <= conglomorateArray.count; n++ {
//        }
//        print(testArray)
//        var splitHashArray = Array<NSValue>(count: dispatchArrayCount, repeatedValue: 0)
//        
//        //Array objects are of type ArraySlice<NSValue> but must be converted to NSValue in order to be fed into the generateCGImagesAsynchronouslyForTime code block
//        for var n = 0; n <= dispatchArrayCount; n++ {
//            //need this line of code figured out
//        //    if let splitHashArray[n]: NSValue = imageHashRate?[0..<9] {
//                //Send to dispatch
//         //   }
//        }
        
        
        //Background threads notes:
        //NEVER DO INTERFACE WORK ON BACKGROUND THREADS!!!
        //dispatch_get_global_queue inputs:
        //QOS_CLASS_USER_INTERACTIVE - highest priority background thread
        //QOS_CLASS_USER_INITIATED - tasks user is actively waiting for to
        //QOS_CLASS_UTILITY - balance between power efficiency and performance
        //QOS_CLASS_BACKGROUND - long running tasks, lowest priority
        //dispatch_async(dispatch_get_main_queue() {  <--get back to main queue
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            imageGenerator.generateCGImagesAsynchronouslyForTimes(imageHashRate1) {(requestedTime, image, actualTime, result, error) -> Void in
                if (result == .Succeeded) {
                    self.flowMoImageArray.append(UIImage(CGImage: image!, scale:1.0, orientation: UIImageOrientation.Right))
                    NSLog("SUCCESS!")
                }
                if (result == .Failed) {
                    
                }
                if (result == .Cancelled) {
                    
                }
            }
        }
        
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            imageGenerator.generateCGImagesAsynchronouslyForTimes(imageHashRate2) {(requestedTime, image, actualTime, result, error) -> Void in
                if (result == .Succeeded) {
                    self.flowMoImageArray.append(UIImage(CGImage: image!, scale:1.0, orientation: UIImageOrientation.Right))
                    NSLog("SUCCESS!")
                }
                if (result == .Failed) {
                    
                }
                if (result == .Cancelled) {
                    
                }
            }
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            imageGenerator.generateCGImagesAsynchronouslyForTimes(imageHashRate3) {(requestedTime, image, actualTime, result, error) -> Void in
                if (result == .Succeeded) {
                    self.flowMoImageArray.append(UIImage(CGImage: image!, scale:1.0, orientation: UIImageOrientation.Right))
                    NSLog("SUCCESS!")
                }
                if (result == .Failed) {
                    
                }
                if (result == .Cancelled) {
                    
                }
            }
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            imageGenerator.generateCGImagesAsynchronouslyForTimes(imageHashRate4) {(requestedTime, image, actualTime, result, error) -> Void in
                if (result == .Succeeded) {
                    self.flowMoImageArray.append(UIImage(CGImage: image!, scale:1.0, orientation: UIImageOrientation.Right))
                    NSLog("SUCCESS!")
                }
                if (result == .Failed) {
                    
                }
                if (result == .Cancelled) {
                    
                }
            }
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            imageGenerator.generateCGImagesAsynchronouslyForTimes(imageHashRate5) {(requestedTime, image, actualTime, result, error) -> Void in
                if (result == .Succeeded) {
                    self.flowMoImageArray.append(UIImage(CGImage: image!, scale:1.0, orientation: UIImageOrientation.Right))
                    NSLog("SUCCESS!")
                }
                if (result == .Failed) {
                    
                }
                if (result == .Cancelled) {
                    
                }
            }
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            imageGenerator.generateCGImagesAsynchronouslyForTimes(imageHashRate6) {(requestedTime, image, actualTime, result, error) -> Void in
                if (result == .Succeeded) {
                    self.flowMoImageArray.append(UIImage(CGImage: image!, scale:1.0, orientation: UIImageOrientation.Right))
                    NSLog("SUCCESS!")
                }
                if (result == .Failed) {
                    
                }
                if (result == .Cancelled) {
                    
                }
            }
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            imageGenerator.generateCGImagesAsynchronouslyForTimes(imageHashRate7) {(requestedTime, image, actualTime, result, error) -> Void in
                if (result == .Succeeded) {
                    self.flowMoImageArray.append(UIImage(CGImage: image!, scale:1.0, orientation: UIImageOrientation.Right))
                    NSLog("SUCCESS!")
                }
                if (result == .Failed) {
                    
                }
                if (result == .Cancelled) {
                    
                }
            }
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            imageGenerator.generateCGImagesAsynchronouslyForTimes(imageHashRate8) {(requestedTime, image, actualTime, result, error) -> Void in
                if (result == .Succeeded) {
                    self.flowMoImageArray.append(UIImage(CGImage: image!, scale:1.0, orientation: UIImageOrientation.Right))
                    NSLog("SUCCESS!")
                }
                if (result == .Failed) {
                    
                }
                if (result == .Cancelled) {
                    
                }
            }
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            imageGenerator.generateCGImagesAsynchronouslyForTimes(imageHashRate9) {(requestedTime, image, actualTime, result, error) -> Void in
                if (result == .Succeeded) {
                    self.flowMoImageArray.append(UIImage(CGImage: image!, scale:1.0, orientation: UIImageOrientation.Right))
                    NSLog("SUCCESS!")
                }
                if (result == .Failed) {
                    
                }
                if (result == .Cancelled) {
                    
                }
                if (conglomorateArray.count == self.flowMoImageArray.count) {
                    print("fire inside")
                    self.presentFlowMoDisplayController(self.flowMoImageArray)
                }
            }
        }
        
    }
    
    func presentFlowMoDisplayController (flowMoImageArray: [UIImage]) {
        let flowMoDisplayController = FlowMoDisplayController()
        flowMoDisplayController.flowMoImageArray = flowMoImageArray
        flowMoDisplayController.flowMoAudioFile = audioRecorder.recordedAudioURL
        self.presentViewController(flowMoDisplayController, animated: false, completion: nil)
    }
}
