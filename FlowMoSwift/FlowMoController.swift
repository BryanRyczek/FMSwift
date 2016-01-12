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
    
    var model = FlowMo.SingletonModel
    
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
    let audioRecorder = FlowMoAudioRecorderPlayer()
    var flowmoAudioDuration : NSTimeInterval?
    var flowmoAudioStartTime : NSTimeInterval?
    //define device screen brightness
    var screenBrightness : CGFloat?
    let flashLayer = CALayer()
    var flowMoImageArray: [UIImage] = []
    // error handling for GCD group
    typealias BatchImageGenerationCompletionClosure = (error: NSError?) -> Void
    //recordingUI
    let innerCircle = CAShapeLayer()
    let outerCircle = CAShapeLayer()
    let flashContainer = CAShapeLayer()
    let bezierObject = BezierObjects()
    //MARK: GCD Helper Variables
    var GlobalMainQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    var GlobalUserInteractiveQueue: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
    }
    var GlobalUserInitiatedQueue: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    }
    var GlobalUtilityQueue: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
    }
    var GlobalBackgroundQueue: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    }
    
    
    //MARK: METHODS
    //MARK: AUDIO METHODS
    func loadAudio() {
        audioRecorder.audioSetup()
    }
    
    //MARK: CAMERA METHODS
    
    func loadCamera(){
        //set camera to highest resolution device will support
        captureSession.sessionPreset = AVCaptureSessionPresetiFrame1280x720
       // captureSession.sessionPreset = AVCaptureSessionPresetHigh
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
        let touchPoint = touches.first as UITouch!
        let screenSize = self.view.bounds.size
        let focusPoint = touchPoint.locationInView(self.view)
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
        
        if (sender.state == UIGestureRecognizerState.Ended){
            isRecording = false
            fireTorch(sender)
            if (torchState == 1 && currentDevice?.position == AVCaptureDevicePosition.Front) {
                flashLayer.removeFromSuperlayer()
                UIScreen.mainScreen().brightness = screenBrightness!
            }
            self.endRecordingElements()
            innerCircle.removeFromSuperlayer()
            audioRecorder.stopRecording()
            print ("stop recording")
            videoFileOutput?.stopRecording()
        }
        else if (sender.state == UIGestureRecognizerState.Began){
            isRecording = true
            recordingElements()
            frontFlash()
            fireTorch(sender)
            let outputPath = NSTemporaryDirectory() + "output.mov"
            let outputFileURL = NSURL(fileURLWithPath: outputPath)
            videoFileOutput?.startRecordingToOutputFileURL(outputFileURL, recordingDelegate: self)
            audioRecorder.recordAudio()
        }
    }
    
// MARK: INTERFACE ELEMENTS AND ANIMATIONS
    
    func flashElements() {
        flashContainer.bounds = CGRect(x:0,y:0,width:70,height:70)
        flashContainer.position = CGPoint(x: 50, y: 45)
        view.layer.addSublayer(flashContainer)
        flashContainer.fillColor = UIColor.clearColor().CGColor
        flashContainer.strokeColor = UIColor.grayColor().CGColor
        
        //// Color Declarations
        let yellowGreen = UIColor(red: 0.626, green: 0.795, blue: 0.164, alpha: 1.000)
        
        //// flashOnFill Drawing
        var flashFillPath = UIBezierPath()
        flashFillPath.moveToPoint(CGPointMake(18.46, 1.55))
        flashFillPath.addLineToPoint(CGPointMake(18.93, 19.21))
        flashFillPath.addLineToPoint(CGPointMake(37.11, 19.21))
        flashFillPath.addLineToPoint(CGPointMake(18.07, 48.19))
        flashFillPath.addLineToPoint(CGPointMake(17.99, 30.61))
        flashFillPath.addLineToPoint(CGPointMake(1.38, 30.69))
        flashFillPath.addLineToPoint(CGPointMake(18.46, 1.55))
        flashFillPath.closePath()
        flashFillPath.miterLimit = 4;
        
        flashFillPath.usesEvenOddFillRule = true;
        
        //yellowGreen.setFill()
        flashFillPath.fill()
        flashContainer.path = flashFillPath.CGPath
    }
    
    func recordingElements() {
        
        let innerOffset = 20.0
        let innerDiameter = 10.0
        let outerDiameter = 24.0
        let xyOffset = (innerDiameter - outerDiameter) / 2
        let innerBounds = CGRect(x: 0, y: 0, width: innerDiameter, height: innerDiameter)
        let outerBounds = CGRect(x: xyOffset, y:xyOffset, width: outerDiameter, height: outerDiameter)
        let outerCircleBounds = CGRect(x: xyOffset - 2.0, y: xyOffset - 2.0, width: outerDiameter + 4.0, height: outerDiameter + 4.0)
        
        // Create CAShapeLayerS
        //let innerCircle = CAShapeLayer()
        innerCircle.bounds = innerBounds
        innerCircle.position = CGPoint(x:self.view.frame.size.width - CGFloat(innerOffset), y: CGFloat(innerOffset))
        view.layer.addSublayer(innerCircle)
        
        outerCircle.bounds = outerCircleBounds
        outerCircle.position = CGPoint(x:self.view.frame.size.width - CGFloat(innerOffset), y: CGFloat(innerOffset))
        view.layer.addSublayer(outerCircle)
        
        outerCircle.strokeColor = UIColor.redColor().CGColor
        outerCircle.lineWidth = 2.0
        outerCircle.fillColor = UIColor.clearColor().CGColor
        
        // fill
        innerCircle.fillColor = UIColor.redColor().CGColor
        // 1
        // begin with a circle with a 50 points radius
        let startShape = UIBezierPath(ovalInRect: innerBounds).CGPath
        // animation end with a large circle with 500 points radius
        let endShape = UIBezierPath(ovalInRect: outerBounds).CGPath
        // set initial shape
        innerCircle.path = startShape
        outerCircle.path = UIBezierPath(ovalInRect: outerCircleBounds).CGPath
        // 2
        // animate the `path`
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = endShape
        animation.duration = 1 // duration is 1 sec
        animation.autoreverses = true
        animation.repeatCount = HUGE
        // 3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
        animation.fillMode = kCAFillModeBoth // keep to value after finishing
        animation.removedOnCompletion = false // don't remove after finishing
        // 4
        innerCircle.addAnimation(animation, forKey: animation.keyPath)
        
        
    if (isRecording == true) {
        view.layer.addSublayer(innerCircle)
    }
    
    }
    
    func endRecordingElements() {
        
        outerCircle.strokeStart = 0.7
        outerCircle.strokeEnd = 1.0
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 1.5
        rotateAnimation.repeatCount = HUGE
        outerCircle.addAnimation(rotateAnimation, forKey: nil)
        
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
      //  , completion: BatchImageGenerationCompletionClosure
        let avURLAsset = AVURLAsset(URL: outputFileURL, options:nil)
        
        let imageGenerator = AVAssetImageGenerator.init(asset: avURLAsset)
        imageGenerator.requestedTimeToleranceAfter=kCMTimeZero
        imageGenerator.requestedTimeToleranceBefore=kCMTimeZero
        
        var imageHashRate = [NSValue]()
        let videoDuration = avURLAsset.duration
        //These floats are calculated to be fed into the below for loop, which generates image hashing times
        let videoDurationFloat = Float(videoDuration.value)
        var flowmoDurationFloat : Float = 1800 // Define length of flomo to be processed based on a timescale of 600 where (600 = 1 second)
        var flowmoStartTimeFloat = videoDurationFloat - flowmoDurationFloat
        // In case of short video, generate proper values to feed into loop (must be less than or equal to zero)
        if (flowmoStartTimeFloat <= 0) {
            flowmoDurationFloat = flowmoDurationFloat + flowmoStartTimeFloat
            flowmoStartTimeFloat = 0
        }
       flowmoAudioDuration = Double(flowmoDurationFloat / Float(600))
       flowmoAudioStartTime = Double(flowmoStartTimeFloat / Float(600))

        for var t = flowmoStartTimeFloat; t < flowmoStartTimeFloat + flowmoDurationFloat; t += 20 {
            let cmTime = CMTimeMake(Int64(t), avURLAsset.duration.timescale)
            let timeValue = NSValue(CMTime: cmTime)
            imageHashRate.append(timeValue)
        }

        let count = imageHashRate.count
        imageGenerator.generateCGImagesAsynchronouslyForTimes(imageHashRate) {(requestedTime, image, actualTime, result, error) -> Void in
            if (result == .Succeeded) {
                self.flowMoImageArray.append(UIImage(CGImage: image!, scale:1.0, orientation: UIImageOrientation.Right))
                if (count == self.flowMoImageArray.count) {
                    self.presentFlowMoDisplayController(self.flowMoImageArray)
                }
            }
        }
  
    }
    
    func presentFlowMoDisplayController (flowMoImageArray: [UIImage]) {
        dispatch_async(GlobalMainQueue){
            
            self.model.setNewAudio(self.audioRecorder.audioRecorder.url)
            self.model.setNewFlowMo(self.flowMoImageArray)
            self.model.setFlowMoAudioStartTime(self.flowmoAudioStartTime!)
            self.model.setFlowMoAudioDuration(self.flowmoAudioDuration!)
//            flowMoDisplayController.flowmoAudioStartTime = self.flowmoAudioStartTime
//            flowMoDisplayController.flowmoAudioDuration = self.flowmoAudioDuration
            let flowMoDisplayController = FlowMoDisplayController()
            self.presentViewController(flowMoDisplayController, animated: false, completion: nil)
        }
    }
    
}

