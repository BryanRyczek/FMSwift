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
import MobileCoreServices // Necessary to import videos from UIImagePicker

class FlowMoController: UIViewController, AVCaptureFileOutputRecordingDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    let flashLayer = CALayer() // White layer for Front Flash
    var flowMoImageArray: [UIImage] = []
    // error handling for GCD group
    typealias BatchImageGenerationCompletionClosure = (error: NSError?) -> Void
    //recordingUI
    let innerCircle = CAShapeLayer()
    let outerCircle = CAShapeLayer()
    
    //UI ELEMENTS
    let elements = AnimationLayers()
    var flashTopLayer = CAShapeLayer()
    var flashBottomLayer = CAShapeLayer()
    let flashScalingConstant : CGFloat = 0.3825
    
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
    
    
    func recordingElements() {
        
        let innerOffset = 20.0
        let innerDiameter = 10.0
        let outerDiameter = 24.0
        let xyOffset = (innerDiameter - outerDiameter) / 2
        let innerBounds = CGRect(x: 0, y: 0, width: innerDiameter, height: innerDiameter)
        let outerBounds = CGRect(x: xyOffset, y:xyOffset, width: outerDiameter, height: outerDiameter)
        let outerCircleBounds = CGRect(x: xyOffset - 2.0, y: xyOffset - 2.0, width: outerDiameter + 4.0, height: outerDiameter + 4.0)
        
        // Create CAShapeLayer
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
        
        let startShape = UIBezierPath(ovalInRect: innerBounds).CGPath
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
    
    func flashElements () {
        
        let flashTopPath = elements.getPathForShape("flashTop")
        let flashBottomPath = elements.getPathForShape("flashBottom")
        
        let transformScale = CGAffineTransformMakeScale(flashScalingConstant, flashScalingConstant)
        flashTopPath.applyTransform(transformScale)
        flashBottomPath.applyTransform(transformScale)
        
        flashTopLayer = elements.makeShapeLayer(flashTopPath)
        flashBottomLayer = elements.makeShapeLayer(flashBottomPath)
        
        print("flashtopLayberbounds \(flashTopLayer.bounds), bottom \(flashBottomLayer.bounds)")
        
        
        let center = self.view.center
        //let centerx = center.x
        print(center)
        
        flashTopLayer.fillColor = UIColor.clearColor().CGColor
        flashTopLayer.strokeColor = UIColor.clearColor().CGColor
        flashTopLayer.lineWidth = 2.0
        flashTopLayer.position = CGPoint(x: (self.view.frame.size.width)/1.6666, y: flashTopLayer.bounds.height)
        
        flashBottomLayer.fillColor = UIColor.clearColor().CGColor
        flashBottomLayer.strokeColor = UIColor.clearColor().CGColor
        flashBottomLayer.lineWidth = 2.0
        flashBottomLayer.position = CGPoint(x: flashTopLayer.position.x + (flashTopLayer.bounds.width), y: flashTopLayer.position.y)
        
        self.view.layer.addSublayer(flashTopLayer)
        self.view.layer.addSublayer(flashBottomLayer)
        
        print(flashBottomLayer.bounds)
        print(flashBottomLayer.position)
        print(flashTopLayer.bounds)
        
    }
    
    func flashAppear() {
        let duration = 0.75
        
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = duration
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 0.868
        animateStrokeEnd.removedOnCompletion = false
        animateStrokeEnd.fillMode = kCAFillModeBoth
        
        let toPoint: CGPoint = CGPointMake(0.0, (15.75 * flashScalingConstant))
        let fromPoint : CGPoint = CGPointZero
        let upPoint: CGPoint = CGPointMake(0.0, (-15.75 * flashScalingConstant))
        
        let animatePosition = CABasicAnimation(keyPath: "position")
        animatePosition.duration = duration
        animatePosition.fromValue = NSValue(CGPoint: fromPoint)
        animatePosition.toValue = NSValue(CGPoint: toPoint)
        animatePosition.additive = true
        animatePosition.fillMode = kCAFillModeBoth // keep to value after finishing
        animatePosition.removedOnCompletion = false // don't remove after finishing
        
        let topAnimation = CABasicAnimation(keyPath: "position")
        topAnimation.duration = duration
        topAnimation.fromValue = NSValue(CGPoint: fromPoint)
        topAnimation.toValue = NSValue(CGPoint: upPoint)
        topAnimation.additive = true
        topAnimation.fillMode = kCAFillModeBoth
        topAnimation.removedOnCompletion = false
        
        // add the animation
        flashTopLayer.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        flashBottomLayer.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        flashTopLayer.strokeColor = UIColor.whiteColor().CGColor
        flashBottomLayer.strokeColor = UIColor.whiteColor().CGColor
        flashBottomLayer.addAnimation(animatePosition, forKey: "position")
        flashTopLayer.addAnimation(topAnimation, forKey:"positionUp")
        
        delay(duration) {
            self.flashTopLayer.fillColor = UIColor.yellowColor().CGColor
            self.flashBottomLayer.fillColor = UIColor.yellowColor().CGColor
        }
        
    }

    func flashDisappear() {
        let duration = 0.75
        
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = duration
        animateStrokeEnd.fromValue = 0.868
        animateStrokeEnd.toValue = 0.0
        animateStrokeEnd.removedOnCompletion = false
        animateStrokeEnd.fillMode = kCAFillModeBoth
        
        let toPoint: CGPoint = CGPointMake(0.0, (15.75 * flashScalingConstant))
        let fromPoint : CGPoint = CGPointZero
        let upPoint: CGPoint = CGPointMake(0.0, (-15.75 * flashScalingConstant))
        
        let animatePosition = CABasicAnimation(keyPath: "position")
        animatePosition.duration = duration
        animatePosition.fromValue = NSValue(CGPoint: toPoint)
        animatePosition.toValue = NSValue(CGPoint: fromPoint)
        animatePosition.additive = true
        animatePosition.fillMode = kCAFillModeBoth // keep to value after finishing
        animatePosition.removedOnCompletion = false // don't remove after finishing
        
        let topAnimation = CABasicAnimation(keyPath: "position")
        topAnimation.duration = duration
        topAnimation.fromValue = NSValue(CGPoint: upPoint)
        topAnimation.toValue = NSValue(CGPoint: fromPoint)
        topAnimation.additive = true
        topAnimation.fillMode = kCAFillModeBoth
        topAnimation.removedOnCompletion = false
        
        // add the animation
        flashTopLayer.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        flashBottomLayer.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        flashBottomLayer.addAnimation(animatePosition, forKey: "position")
        flashTopLayer.addAnimation(topAnimation, forKey:"positionUp")
        
        delay(duration) {
            self.flashTopLayer.fillColor = UIColor.clearColor().CGColor
            self.flashBottomLayer.fillColor = UIColor.clearColor().CGColor
            self.flashTopLayer.fillColor = UIColor.clearColor().CGColor
            self.flashBottomLayer.fillColor = UIColor.clearColor().CGColor

        }
    }
    
// MARK: FLASH METHODS
    
    func fireTorch(sender: AnyObject) {
        
    if let device = currentDevice {
            
            if (device.hasTorch && torchState==1) {
                do {
                    print("Torch mode is working")
                    try device.lockForConfiguration()
                    if (device.torchMode == AVCaptureTorchMode.On) {
                        device.torchMode = AVCaptureTorchMode.Off
                    } else {
                        do {
                            try device.setTorchModeOnWithLevel(1.0)
                        } catch {
                            print(error)
                        }
                    }
                    device.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func setTorchMode(sender: AnyObject) {
        if (torchState == 0)
        {
            torchState++
            flashAppear()
            print(torchState, "has changed")
        }
        else
        {
            torchState = 0
            flashDisappear()
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
    
    // MARK: VIDEO UPLOAD METHODS
    
    func uploadVideo() {
        let picker = UIImagePickerController()
        print(picker.mediaTypes)
        picker.allowsEditing = false
        picker.delegate = self
        picker.mediaTypes = [kUTTypeMovie as String]
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        print(info)
        let videoString = info[UIImagePickerControllerMediaURL]
        print(videoString)
        if let vString = videoString {
            let string = String(vString)
            print(string)
            let videoURL = NSURL(string: string)
            print("transform \(videoURL)")
            generateImageSequence(videoURL!)
        }
       // print(videoString)
       
//        let videoURL = NSURL(fileURLWithPath: videoString)
//        print(videoURL)
//        generateImageSequence(videoURL)

        
//        var newImage: UIImage
//        
//        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            newImage = possibleImage
//        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//            newImage = possibleImage
//        } else {
//            return
//        }
        
        // do something interesting here!
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
   // MARK: FILE PROCESSING METHODS
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        if error != nil {
            print(error)
            return
        }
        let urlString = outputFileURL.absoluteString
        print(outputFileURL)
        saveVideoToCameraRoll(outputFileURL)
        generateImageSequence(outputFileURL)
    }
    
    func saveVideoToCameraRoll(outputFileURL: NSURL!) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(outputFileURL)
            }, completionHandler: { success, error in
                if !success { NSLog("Failed to create video: %@", error!) }
        })
    }
    
    func extractAudioFromVideo(outputFileURL: NSURL) {
        
    }
    
    func generateImageSequence(outputFileURL: NSURL) {
        //print("generate \(outputFileURL)")
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
            //reset outerCircle
            self.outerCircle.removeFromSuperlayer()
            self.outerCircle.strokeStart = 0.0
            //set model
            print(self.audioRecorder.audioRecorder.url.description)
            self.model.setNewAudio(self.audioRecorder.audioRecorder.url)
            self.model.setNewFlowMo(self.flowMoImageArray)
            self.model.setFlowMoAudioStartTime(self.flowmoAudioStartTime!)
            self.model.setFlowMoAudioDuration(self.flowmoAudioDuration!)
            let flowMoDisplayController = FlowMoDisplayController()
            self.flowMoImageArray.removeAll()
            self.presentViewController(flowMoDisplayController, animated: false, completion: nil)
        }
    }


    
}

