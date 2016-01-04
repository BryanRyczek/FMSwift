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
    let audioRecorder = FlowMoAudioRecorderPlayer()
    //define device screen brightness
    var screenBrightness : CGFloat?
    let flashLayer = CALayer()
    var flowMoImageArray: [UIImage] = []
    // error handling for GCD group
    typealias BatchImageGenerationCompletionClosure = (error: NSError?) -> Void
    //recordingUI
    let recordingCircle = CAShapeLayer()
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
        //cont
        //if we are not currently recording
        if (sender.state == UIGestureRecognizerState.Ended){
            isRecording = false
            recordingElements()
            fireTorch(sender)
            if (torchState == 1 && currentDevice?.position == AVCaptureDevicePosition.Front) {
                flashLayer.removeFromSuperlayer()
                UIScreen.mainScreen().brightness = screenBrightness!
            }
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
    
    func recordingElements() {
        
        let innerDiameter = 20.0
        let outerDiameter = 24.0
        let xyOffset = (innerDiameter - outerDiameter) / 2
        let innerBounds = CGRect(x: 0, y: 0, width: innerDiameter, height: innerDiameter)
        let outerBounds = CGRect(x: xyOffset, y:xyOffset, width: outerDiameter, height: outerDiameter)
        
        // Create CAShapeLayerS
        //let recordingCircle = CAShapeLayer()
        recordingCircle.bounds = innerBounds
        recordingCircle.position = CGPoint(x:self.view.frame.size.width - CGFloat(innerDiameter), y: CGFloat(innerDiameter))
        print(recordingCircle.position)
        view.layer.addSublayer(recordingCircle)
        
        // fill with yellow
        recordingCircle.fillColor = UIColor.redColor().CGColor
        // 1
        // begin with a circle with a 50 points radius
        let startShape = UIBezierPath(ovalInRect: innerBounds).CGPath
        // animation end with a large circle with 500 points radius
        let endShape = UIBezierPath(ovalInRect: outerBounds).CGPath
        // set initial shape
        recordingCircle.path = startShape
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
        recordingCircle.addAnimation(animation, forKey: animation.keyPath)

    if (isRecording == true) {
        view.layer.addSublayer(recordingCircle)
    } else if (isRecording == false) {
        //nothing
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
       
        for var t = flowmoStartTimeFloat; t < flowmoStartTimeFloat + flowmoDurationFloat; t += 20 {
            let cmTime = CMTimeMake(Int64(t), avURLAsset.duration.timescale)
            let timeValue = NSValue(CMTime: cmTime)
            imageHashRate.append(timeValue)
        }

        let count = imageHashRate.count
        imageGenerator.generateCGImagesAsynchronouslyForTimes(imageHashRate) {(requestedTime, image, actualTime, result, error) -> Void in
            if (result == .Succeeded) {
                self.flowMoImageArray.append(UIImage(CGImage: image!, scale:1.0, orientation: UIImageOrientation.Right))
                NSLog("SUCCESS!")
                if (count == self.flowMoImageArray.count) {
                    print("fire inside")
                    self.presentFlowMoDisplayController(self.flowMoImageArray)
                }
            } else if (result == .Failed) {
                
            } else if (result == .Cancelled) {
                
            }
        }
  
    }
    
    func presentFlowMoDisplayController (flowMoImageArray: [UIImage]) {
        dispatch_async(GlobalMainQueue){
            let flowMoDisplayController = FlowMoDisplayController()
            self.recordingCircle.removeFromSuperlayer()
            flowMoDisplayController.flowMoImageArray = flowMoImageArray
       //     flowMoDisplayController.flowMoAudioFile = audioRecorder.audioRecorder.url
            self.presentViewController(flowMoDisplayController, animated: false, completion: nil)
        }
    }
    
}


//    //// General Declarations
//    let context = UIGraphicsGetCurrentContext()
//    CGContextSaveGState(context)
//    CGContextScaleCTM(context, 1.8, 1.8)
//    let color = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
//    let recordingText = CAShapeLayer()
////        recordingText.bounds =  bounds
//        recordingText.position = CGPoint(x: center.x + ((self.view.frame.size.width/2)-CGFloat(55+diameter)), y: center.y - ((self.view.frame.size.height/2)-CGFloat(14)))
//        var recordingTextPath = UIBezierPath()
//        recordingTextPath.moveToPoint(CGPointMake(0, 14.62))
//        recordingTextPath.addLineToPoint(CGPointMake(5.6, 14.62))
//        recordingTextPath.addLineToPoint(CGPointMake(5.6, 13.03))
//        recordingTextPath.addLineToPoint(CGPointMake(3.83, 13.03))
//        recordingTextPath.addLineToPoint(CGPointMake(3.83, 8.81))
//        recordingTextPath.addLineToPoint(CGPointMake(5.54, 8.81))
//        recordingTextPath.addCurveToPoint(CGPointMake(7.04, 9.61), controlPoint1: CGPointMake(6.41, 8.81), controlPoint2: CGPointMake(6.68, 9))
//        recordingTextPath.addLineToPoint(CGPointMake(9.26, 13.54))
//        recordingTextPath.addCurveToPoint(CGPointMake(11.26, 14.62), controlPoint1: CGPointMake(9.75, 14.39), controlPoint2: CGPointMake(10.04, 14.62))
//        recordingTextPath.addLineToPoint(CGPointMake(12.48, 14.62))
//        recordingTextPath.addLineToPoint(CGPointMake(12.48, 13.03))
//        recordingTextPath.addLineToPoint(CGPointMake(12.05, 13.03))
//        recordingTextPath.addCurveToPoint(CGPointMake(11.05, 12.56), controlPoint1: CGPointMake(11.54, 13.03), controlPoint2: CGPointMake(11.28, 12.95))
//        recordingTextPath.addLineToPoint(CGPointMake(9.02, 9.02))
//        recordingTextPath.addCurveToPoint(CGPointMake(8.41, 8.35), controlPoint1: CGPointMake(8.77, 8.55), controlPoint2: CGPointMake(8.41, 8.35))
//        recordingTextPath.addLineToPoint(CGPointMake(8.41, 8.31))
//        recordingTextPath.addCurveToPoint(CGPointMake(11.38, 4.27), controlPoint1: CGPointMake(10.24, 7.84), controlPoint2: CGPointMake(11.38, 6.35))
//        recordingTextPath.addCurveToPoint(CGPointMake(8.88, 0.55), controlPoint1: CGPointMake(11.38, 2.32), controlPoint2: CGPointMake(10.38, 1.06))
//        recordingTextPath.addCurveToPoint(CGPointMake(6.23, 0.24), controlPoint1: CGPointMake(8.08, 0.28), controlPoint2: CGPointMake(7.25, 0.24))
//        recordingTextPath.addLineToPoint(CGPointMake(0, 0.24))
//        recordingTextPath.addLineToPoint(CGPointMake(0, 1.81))
//        recordingTextPath.addLineToPoint(CGPointMake(1.79, 1.81))
//        recordingTextPath.addLineToPoint(CGPointMake(1.79, 13.03))
//        recordingTextPath.addLineToPoint(CGPointMake(0, 13.03))
//        recordingTextPath.addLineToPoint(CGPointMake(0, 14.62))
//        recordingTextPath.closePath()
//        recordingTextPath.moveToPoint(CGPointMake(3.83, 7.15))
//        recordingTextPath.addLineToPoint(CGPointMake(3.83, 1.91))
//        recordingTextPath.addLineToPoint(CGPointMake(6.21, 1.91))
//        recordingTextPath.addCurveToPoint(CGPointMake(7.98, 2.18), controlPoint1: CGPointMake(6.9, 1.91), controlPoint2: CGPointMake(7.51, 1.99))
//        recordingTextPath.addCurveToPoint(CGPointMake(9.32, 4.44), controlPoint1: CGPointMake(8.88, 2.54), controlPoint2: CGPointMake(9.32, 3.32))
//        recordingTextPath.addCurveToPoint(CGPointMake(6.72, 7.15), controlPoint1: CGPointMake(9.32, 6.13), controlPoint2: CGPointMake(8.28, 7.15))
//        recordingTextPath.addLineToPoint(CGPointMake(3.83, 7.15))
//        recordingTextPath.closePath()
//        recordingTextPath.moveToPoint(CGPointMake(14.19, 14.62))
//        recordingTextPath.addLineToPoint(CGPointMake(24.94, 14.62))
//        recordingTextPath.addLineToPoint(CGPointMake(24.94, 11.22))
//        recordingTextPath.addLineToPoint(CGPointMake(23.17, 11.22))
//        recordingTextPath.addLineToPoint(CGPointMake(23.17, 12.95))
//        recordingTextPath.addLineToPoint(CGPointMake(18.02, 12.95))
//        recordingTextPath.addLineToPoint(CGPointMake(18.02, 8.2))
//        recordingTextPath.addLineToPoint(CGPointMake(23.1, 8.2))
//        recordingTextPath.addLineToPoint(CGPointMake(23.1, 6.53))
//        recordingTextPath.addLineToPoint(CGPointMake(18.02, 6.53))
//        recordingTextPath.addLineToPoint(CGPointMake(18.02, 1.91))
//        recordingTextPath.addLineToPoint(CGPointMake(22.82, 1.91))
//        recordingTextPath.addLineToPoint(CGPointMake(22.82, 3.58))
//        recordingTextPath.addLineToPoint(CGPointMake(24.59, 3.58))
//        recordingTextPath.addLineToPoint(CGPointMake(24.59, 0.24))
//        recordingTextPath.addLineToPoint(CGPointMake(14.19, 0.24))
//        recordingTextPath.addLineToPoint(CGPointMake(14.19, 1.81))
//        recordingTextPath.addLineToPoint(CGPointMake(15.98, 1.81))
//        recordingTextPath.addLineToPoint(CGPointMake(15.98, 13.03))
//        recordingTextPath.addLineToPoint(CGPointMake(14.19, 13.03))
//        recordingTextPath.addLineToPoint(CGPointMake(14.19, 14.62))
//        recordingTextPath.closePath()
//        recordingTextPath.moveToPoint(CGPointMake(26.97, 7.35))
//        recordingTextPath.addCurveToPoint(CGPointMake(34.4, 14.86), controlPoint1: CGPointMake(26.97, 11.54), controlPoint2: CGPointMake(30.09, 14.86))
//        recordingTextPath.addCurveToPoint(CGPointMake(40, 12.03), controlPoint1: CGPointMake(36.4, 14.86), controlPoint2: CGPointMake(40, 14.15))
//        recordingTextPath.addLineToPoint(CGPointMake(40, 10.28))
//        recordingTextPath.addLineToPoint(CGPointMake(38.11, 10.28))
//        recordingTextPath.addLineToPoint(CGPointMake(38.11, 11.4))
//        recordingTextPath.addCurveToPoint(CGPointMake(34.52, 13.09), controlPoint1: CGPointMake(38.11, 12.72), controlPoint2: CGPointMake(35.54, 13.09))
//        recordingTextPath.addCurveToPoint(CGPointMake(29.07, 7.27), controlPoint1: CGPointMake(31.39, 13.09), controlPoint2: CGPointMake(29.07, 10.67))
//        recordingTextPath.addCurveToPoint(CGPointMake(34.4, 1.75), controlPoint1: CGPointMake(29.07, 4.01), controlPoint2: CGPointMake(31.33, 1.75))
//        recordingTextPath.addCurveToPoint(CGPointMake(37.9, 3.48), controlPoint1: CGPointMake(35.73, 1.75), controlPoint2: CGPointMake(37.9, 2.22))
//        recordingTextPath.addLineToPoint(CGPointMake(37.9, 4.6))
//        recordingTextPath.addLineToPoint(CGPointMake(39.8, 4.6))
//        recordingTextPath.addLineToPoint(CGPointMake(39.8, 2.85))
//        recordingTextPath.addCurveToPoint(CGPointMake(34.32, 0), controlPoint1: CGPointMake(39.8, 0.63), controlPoint2: CGPointMake(36.05, 0))
//        recordingTextPath.addCurveToPoint(CGPointMake(26.97, 7.35), controlPoint1: CGPointMake(30.17, 0), controlPoint2: CGPointMake(26.97, 3.13))
//        recordingTextPath.closePath()
//    recordingText.path = recordingTextPath.CGPath
//        color.setFill()
//        recordingTextPath.fill()
//    view.layer.addSublayer(recordingText)
//
//    CGContextRestoreGState(context)

//    let recordingTextRect = CGRectMake(11.67, 15.28, 36, 24)
//    let recordingTextStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
//    recordingTextStyle.alignment = NSTextAlignment.Left
//
//    let recordingTextFontAttributes = [NSFontAttributeName: UIFont(name: "Courier", size: 12)!, NSForegroundColorAttributeName: UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000), NSParagraphStyleAttributeName: recordingTextStyle]
//
//    "REC".drawInRect(recordingTextRect, withAttributes: recordingTextFontAttributes)