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

func getDocumentsURL() -> NSURL {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    return documentsURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    
    let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
    return fileURL.path!
    
}

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
    //GCD Helper Variables
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
            captureAnimationBar()
            frontFlash()
            print ("start recording")
            fireTorch(sender)
            let outputPath = NSTemporaryDirectory() + "output.mov"
            let outputFileURL = NSURL(fileURLWithPath: outputPath)
            videoFileOutput?.startRecordingToOutputFileURL(outputFileURL, recordingDelegate: self)
            audioRecorder.recordAudio()
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
        
        var imageHashRate0 = [NSValue]()
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
        // In case of short video, generate proper values to feed into loop (must be less than or equal to zero)
        if (flowmoStartTimeFloat <= 0) {
            flowmoDurationFloat = flowmoDurationFloat + flowmoStartTimeFloat
            flowmoStartTimeFloat = 0
        }
       
        
        
        for var t = flowmoStartTimeFloat; t < flowmoStartTimeFloat + flowmoDurationFloat; t += 20 {
            let cmTime = CMTimeMake(Int64(t), avURLAsset.duration.timescale)
            let timeValue = NSValue(CMTime: cmTime)
            switch (t < (flowmoStartTimeFloat+flowmoDurationFloat))
            {
            case t <= (flowmoStartTimeFloat+flowmoDurationFloat)*0.1:
                imageHashRate0.append(timeValue)
            case ((flowmoStartTimeFloat+flowmoDurationFloat)*0.1 < t) && (t <= (flowmoStartTimeFloat+flowmoDurationFloat)*0.2):
                imageHashRate1.append(timeValue)
            case ((flowmoStartTimeFloat+flowmoDurationFloat)*0.2 < t) && (t <= (flowmoStartTimeFloat+flowmoDurationFloat)*0.3):
                imageHashRate2.append(timeValue)
            case ((flowmoStartTimeFloat+flowmoDurationFloat)*0.3 < t) && (t <= (flowmoStartTimeFloat+flowmoDurationFloat)*0.4):
                imageHashRate3.append(timeValue)
            case ((flowmoStartTimeFloat+flowmoDurationFloat)*0.4 < t) && (t <= (flowmoStartTimeFloat+flowmoDurationFloat)*0.5):
                imageHashRate4.append(timeValue)
            case ((flowmoStartTimeFloat+flowmoDurationFloat)*0.5 < t) && (t <= (flowmoStartTimeFloat+flowmoDurationFloat)*0.6):
                imageHashRate5.append(timeValue)
            case ((flowmoStartTimeFloat+flowmoDurationFloat)*0.6 < t) && (t <= (flowmoStartTimeFloat+flowmoDurationFloat)*0.7):
                imageHashRate6.append(timeValue)
            case ((flowmoStartTimeFloat+flowmoDurationFloat)*0.7 < t) && (t <= (flowmoStartTimeFloat+flowmoDurationFloat)*0.8):
                imageHashRate7.append(timeValue)
            case ((flowmoStartTimeFloat+flowmoDurationFloat)*0.8 < t) && (t <= (flowmoStartTimeFloat+flowmoDurationFloat)*0.9):
                imageHashRate8.append(timeValue)
            case ((flowmoStartTimeFloat+flowmoDurationFloat)*0.9 < t) && (t <= (flowmoStartTimeFloat+flowmoDurationFloat)):
                imageHashRate9.append(timeValue)
            default:
                print("Hash Rate Arrays Complete")
            }
            
            }
        
        var conglomerateArray = [NSArray]()
        
        conglomerateArray.append(imageHashRate0)
        conglomerateArray.append(imageHashRate1)
        conglomerateArray.append(imageHashRate2)
        conglomerateArray.append(imageHashRate3)
        conglomerateArray.append(imageHashRate4)
        conglomerateArray.append(imageHashRate5)
        conglomerateArray.append(imageHashRate6)
        conglomerateArray.append(imageHashRate7)
        conglomerateArray.append(imageHashRate8)
        conglomerateArray.append(imageHashRate9)
        
        print(conglomerateArray.count)
        print(conglomerateArray[0])
        
        print("hi")
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
     
        //Background threads notes:
        //NEVER DO INTERFACE WORK ON BACKGROUND THREADS!!!
        //dispatch_get_global_queue inputs:
        //QOS_CLASS_USER_INTERACTIVE - highest priority background thread
        //QOS_CLASS_USER_INITIATED - tasks user is actively waiting for to
        //QOS_CLASS_UTILITY - balance between power efficiency and performance
        //QOS_CLASS_BACKGROUND - long running tasks, lowest priority
        //dispatch_async(dispatch_get_main_queue() {  <--get back to main queue
        var i : Int = 0
        
        dispatch_async(GlobalUserInteractiveQueue) {
            var storedError: NSError!
            var processingGroup = dispatch_group_create()
            
            for array in conglomerateArray {
                dispatch_group_enter(processingGroup)
                imageGenerator.generateCGImagesAsynchronouslyForTimes(array as! [NSValue]) {(requestedTime, image, actualTime, result, error) -> Void in
                    if (result == .Succeeded) {
                        self.flowMoImageArray.append(UIImage(CGImage: image!, scale:1.0, orientation: UIImageOrientation.Right))
                        
//                        let imageName = "flowmo\(i)"
//                        let imagePath = fileInDocumentsDirectory(imageName)
//                        self.saveImage(UIImage(CGImage: image!, scale:1.0, orientation: UIImageOrientation.Right), path: imagePath)
                        NSLog("SUCCESS! \(image!)")
//                        i++
                        
                    }
                    if (result == .Failed) {
                        
                    }
                    if (result == .Cancelled) {
                        
                    }
                }
                dispatch_group_leave(processingGroup)
            }
            dispatch_group_wait(processingGroup, DISPATCH_TIME_FOREVER)
            dispatch_async(self.GlobalMainQueue) {
                //Completion Handler
            }
        }
//    
//                if (conglomerateArray.count == self.flowMoImageArray.count) {
//                    print("fire inside")
//                    self.presentFlowMoDisplayController(self.flowMoImageArray)
//                }
    }
    
    func presentFlowMoDisplayController (flowMoImageArray: [UIImage]) {
        let flowMoDisplayController = FlowMoDisplayController()
        flowMoDisplayController.flowMoImageArray = flowMoImageArray
        flowMoDisplayController.flowMoAudioFile = audioRecorder.audioRecorder.url
        self.presentViewController(flowMoDisplayController, animated: false, completion: nil)
    }
    
    //MARK: IMAGE SAVING METHODS
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData!.writeToFile(path, atomically: true)
        
        return result
        
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
    }
    
}
