//
//  ScreenBufferTestCode.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/17/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import UIKit

class ScreenBufferTestCode: UIViewController {

    
//    let videoDataOutput = AVCaptureVideoDataOutput()
//    let stillCameraOutput = AVCaptureStillImageOutput()
//    var sessionQueue:dispatch_queue_t = dispatch_queue_create("com.example.session_access_queue", DISPATCH_QUEUE_SERIAL)
//    var flowMoImageArray: [UIImage] = []
//    //timer to capture frames @ 30 fps
//    var bufferTimer: NSTimer!
    

    
    //    func realtimeCam() {
    //        captureSession.sessionPreset = AVCaptureSessionPresetHigh
    //        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
    //        for device in devices {
    //            if device.position == AVCaptureDevicePosition.Back {
    //                backFacingCamera = device
    //            } else if device.position == AVCaptureDevicePosition.Front {
    //                frontFacingCamera = device
    //            }
    //        }
    //        currentDevice = backFacingCamera
    //        let captureDeviceInput:AVCaptureDeviceInput
    //        do {
    //            captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice)
    //        } catch {
    //            print(error)
    //            return
    //        }
    //        do {
    //            //AVCaptureDeviceFormat allows for setting of framerate
    //            var finalFormat = AVCaptureDeviceFormat()
    //            var maxFps: Double = 0
    //            var maxFpsDesired: Double = 30
    //            for vFormat in currentDevice!.formats {
    //                var ranges = vFormat.videoSupportedFrameRateRanges as! [AVFrameRateRange]
    //                let frameRates = ranges[0]
    //                print(frameRates)
    //
    //                if frameRates.maxFrameRate >= maxFps && frameRates.maxFrameRate <= maxFpsDesired {
    //                    maxFps = frameRates.maxFrameRate
    //                    print("Max fps")
    //                    print(maxFps)
    //                    finalFormat = vFormat as! AVCaptureDeviceFormat
    //                }
    //            }
    //            if maxFps != 0 {
    //            let timeValue = Int64(1800.0 / maxFps)
    //            let timeScale: Int32 = 1800
    //                print(timeValue)
    //                print(timeScale)
    //                do {
    //                    try currentDevice!.lockForConfiguration()
    //                } catch {
    //                    print(error)
    //                    return
    //                }
    //            currentDevice!.activeFormat = finalFormat
    //            currentDevice!.activeVideoMinFrameDuration = CMTimeMake(timeValue, timeScale)
    //            currentDevice!.activeVideoMaxFrameDuration = CMTimeMake(timeValue, timeScale)
    //                print(currentDevice!.activeVideoMaxFrameDuration)
    //                print(currentDevice!.activeVideoMinFrameDuration)
    //            currentDevice!.unlockForConfiguration()
    //        }
    //        captureSession.addInput(captureDeviceInput)
    //
    //        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey: Int(kCVPixelFormatType_32BGRA)]
    //        videoDataOutput.alwaysDiscardsLateVideoFrames = true
    //        videoDataOutput.setSampleBufferDelegate(self, queue: sessionQueue)
    //        if captureSession.canAddOutput(videoDataOutput){
    //            captureSession.addOutput(videoDataOutput)
    //        }
    //        if self.captureSession.canAddOutput(self.stillCameraOutput) {
    //            self.captureSession.addOutput(self.stillCameraOutput)
    //        }
    //
    //        }
    //    }
    
    //    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
    //            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
    //            let image = CIImage(CVPixelBuffer: pixelBuffer!)
    //    }
    //
    //    func retainImageFromBuffer(sender: AnyObject) {
    //
    //    dispatch_async(sessionQueue) { () -> Void in
    //
    //    let connection = self.stillCameraOutput.connectionWithMediaType(AVMediaTypeVideo)
    //
    //    // update the video orientation to the device one
    //    connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.currentDevice().orientation.rawValue)!
    //
    //    self.stillCameraOutput.captureStillImageAsynchronouslyFromConnection(connection) {
    //    (imageDataSampleBuffer, error) -> Void in
    //
    //    if error == nil {
    //
    //    // if the session preset .Photo is used, or if explicitly set in the device's outputSettings
    //    // we get the data already compressed as JPEG
    //
    //    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
    //
    //    // the sample buffer also contains the metadata, in case we want to modify it
    //    let metadata:NSDictionary = CMCopyDictionaryOfAttachments(nil, imageDataSampleBuffer, CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))!
    //    
    //    if let image = UIImage(data: imageData) {
    //        self.flowMoImageArray.append(image)
    //        print(self.flowMoImageArray.count)
    //        }
    //    } else {
    //    NSLog("error while capturing still image: \(error)")
    //            }
    //        }
    //    }
    //}
    

    
}
