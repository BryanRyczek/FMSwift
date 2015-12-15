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

class FlowMoController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
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
   
    var torchState = 0
    
    let videoDataOutput = AVCaptureVideoDataOutput()
    let stillCameraOutput = AVCaptureStillImageOutput()
    var sessionQueue:dispatch_queue_t = dispatch_queue_create("com.example.session_access_queue", DISPATCH_QUEUE_SERIAL)
    var flowMoImageArray: [UIImage] = []
    
    //MARK: Relegated video variables
    // define video output
    var videoFileOutput : AVCaptureMovieFileOutput?
    
    //MARK: METHODS
    //MARK: CAMERA METHODS
    func realtimeCam() {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
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
        do {
            //AVCaptureDeviceFormat allows for setting of framerate
            var finalFormat = AVCaptureDeviceFormat()
            var maxFps: Double = 0
            var maxFpsDesired: Double = 60
            for vFormat in currentDevice!.formats {
                var ranges = vFormat.videoSupportedFrameRateRanges as! [AVFrameRateRange]
                let frameRates = ranges[0]
                
                if frameRates.maxFrameRate >= maxFps && frameRates.maxFrameRate <= maxFpsDesired {
                    maxFps = frameRates.maxFrameRate
                    finalFormat = vFormat as! AVCaptureDeviceFormat
                }
            }
            if maxFps != 0 {
            let timeValue = Int64(1800.0 / maxFps)
            let timeScale: Int32 = 1800
                do {
                    try currentDevice!.lockForConfiguration()
                } catch {
                    print(error)
                    return
                }
            currentDevice!.activeFormat = finalFormat
            currentDevice!.activeVideoMinFrameDuration = CMTimeMake(timeValue, timeScale)
            currentDevice!.activeVideoMaxFrameDuration = CMTimeMake(timeValue, timeScale)
                print(currentDevice!.activeVideoMaxFrameDuration)
                print(currentDevice!.activeVideoMinFrameDuration)
            currentDevice!.unlockForConfiguration()
        }
        captureSession.addInput(captureDeviceInput)
        
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey: Int(kCVPixelFormatType_32BGRA)]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        if captureSession.canAddOutput(videoDataOutput){
            captureSession.addOutput(videoDataOutput)
        }
        if self.captureSession.canAddOutput(self.stillCameraOutput) {
            self.captureSession.addOutput(self.stillCameraOutput)
        }
        
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            let image = CIImage(CVPixelBuffer: pixelBuffer!)
    }
    
    func retainImageFromBuffer(sender: AnyObject) {
        
    dispatch_async(sessionQueue) { () -> Void in
    
    let connection = self.stillCameraOutput.connectionWithMediaType(AVMediaTypeVideo)
    
    // update the video orientation to the device one
    connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.currentDevice().orientation.rawValue)!
    
    self.stillCameraOutput.captureStillImageAsynchronouslyFromConnection(connection) {
    (imageDataSampleBuffer, error) -> Void in
    
    if error == nil {
    
    // if the session preset .Photo is used, or if explicitly set in the device's outputSettings
    // we get the data already compressed as JPEG
    
    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
    
    // the sample buffer also contains the metadata, in case we want to modify it
    let metadata:NSDictionary = CMCopyDictionaryOfAttachments(nil, imageDataSampleBuffer, CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))!
    
    if let image = UIImage(data: imageData) {
        self.flowMoImageArray.append(image)
        print(self.flowMoImageArray.count)
        }
    } else {
    NSLog("error while capturing still image: \(error)")
            }
        }
    }
}

    //FIXME: put in permissions directives
        func handleCameraPermissions(){ let authorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch authorizationStatus {
        case .NotDetermined:
            // permission dialog not yet presented, request authorization
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo,
                completionHandler: { (granted:Bool) -> Void in
                    if granted {
                        // go ahead
                    }
                    else {
                        // user denied, nothing much to do
                    }
            })
        case .Authorized:
            break
        case .Denied, .Restricted:
            //Ask user to change permissions in settings
            break
        }
        }
    
    func capture (sender: UILongPressGestureRecognizer) {  //cont
        //if we are not currently recording
        if (sender.state == UIGestureRecognizerState.Ended){
            isRecording = false
            //videoFileOutput?.stopRecording()
            fireTorch(sender)
            print ("stop recording")
        }
        else if (sender.state == UIGestureRecognizerState.Began){
            isRecording = true
            captureAnimationBar()
            print ("start recording")
            fireTorch(sender)
            //let outputPath = NSTemporaryDirectory() + "output.mov"
            //let outputFileURL = NSURL(fileURLWithPath: outputPath)
            //videoFileOutput?.startRecordingToOutputFileURL(outputFileURL, recordingDelegate: self)
        }}
    
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

// MARK: RELEGATED CAMERA METHODS
//    func loadCamera(){
//    //set camera to highest resolution device will support
//    captureSession.sessionPreset = AVCaptureSessionPresetHigh
//    // create array of available devices (front camera, back camera, microphone)
//    let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
//        
//    for device in devices {
//        if device.position == AVCaptureDevicePosition.Back {
//            backFacingCamera = device
//        } else if device.position == AVCaptureDevicePosition.Front {
//            frontFacingCamera = device
//        }
//    }
//        
//    currentDevice = backFacingCamera
//    
//    let captureDeviceInput:AVCaptureDeviceInput
//        do {
//            captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice)
//        } catch {
//            print(error)
//            return
//    }
//    
//    //create instance used to save data for movie file
//    videoFileOutput = AVCaptureMovieFileOutput()
//    videoFileOutput?.maxRecordedDuration
//        
//    //create instance used to save audio data
//        
//    let audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
//        
//    let audioInput:AVCaptureDeviceInput
//        do {
//            audioInput = try AVCaptureDeviceInput(device:audioDevice)
//        } catch {
//            print(error)
//            return
//    }
//    
//    audioFileOutput = AVCaptureAudioDataOutput()
//        
//    //Assign the input and output devices to the capture session
//    //captureSession.addInput(captureDeviceInput)
//    captureSession.addInput(audioInput)
//    captureSession.addOutput(videoFileOutput)
//    captureSession.addOutput(audioFileOutput)
//        
//    }
    
    
    
    //MARK: FILE PROCESSING METHODS
//    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
//        if error != nil {
//            print(error)
//            return
//        }
//        let urlString = outputFileURL.absoluteString
//        saveVideoToCameraRoll(outputFileURL)
//        generateImageSequence(outputFileURL)
//    }
//    
//    func saveVideoToCameraRoll(outputFileURL: NSURL!) {
//        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
//            let request = PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(outputFileURL)
//            }, completionHandler: { success, error in
//                if !success { NSLog("Failed to create video: %@", error!) }
//        })
//    }
    
    
//    func generateImageSequence(outputFileURL: NSURL) {
//        let avURLAsset = AVURLAsset(URL: outputFileURL, options:nil)
//        
//        
//        let imageGenerator = AVAssetImageGenerator.init(asset: avURLAsset)
//        imageGenerator.requestedTimeToleranceAfter=kCMTimeZero
//        imageGenerator.requestedTimeToleranceBefore=kCMTimeZero
//        
//        var imageHashRate: [NSValue] = []
//        //NEED TO PLUG THESE VALUES INTO THE BELOW LOOP TO GENERATE imageHashRateArray ONCE FURTHER WORK DONE
//        var loopDuration = avURLAsset.duration.value
//        let timeValue = Float(CMTimeGetSeconds(avURLAsset.duration))
//        
//        for var t = 0; t < 1800; t += 20 {
//            let cmTime = CMTimeMake(Int64(t), avURLAsset.duration.timescale)
//            let timeValue = NSValue(CMTime: cmTime)
//            imageHashRate.append(timeValue)
//            }
//        
//        var flowMoImageArray: [UIImage] = []
//        imageGenerator.generateCGImagesAsynchronouslyForTimes(imageHashRate) {(requestedTime, image, actualTime, result, error) -> Void in
//            if (result == .Succeeded) {
//                flowMoImageArray.append(UIImage(CGImage: image!))
//            }
//            if (result == .Failed) {
//                
//            }
//            if (result == .Cancelled) {
//                
//            }
//        }
//    }
    
}
