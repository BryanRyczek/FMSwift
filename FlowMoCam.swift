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

class FlowMoCam: FlowMoController {
    
    var backFacingCamera:AVCaptureDevice?
    var frontFacingCamera:AVCaptureDevice?
    var currentDevice:AVCaptureDevice?
    var torchState: Int =  0
    
    override func viewDidLoad() {

        super.viewDidLoad()
        //set camera to highest resolution device will support
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        // create array of available devices (front camera, back camera, microphone)
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        print(devices)
        
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
        toggleCameraButton()
        toggleTorchButton()
        
    }
    
    func captureButton() {
        let captureButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        captureButton.frame = CGRectMake((self.view.frame.width/2)-35, (self.view.frame.height)-105, 70, 70)
        captureButton.backgroundColor = UIColor.whiteColor()
        let longPressCaptureRecognizer = UILongPressGestureRecognizer(target: self, action: "capture:")
        longPressCaptureRecognizer.minimumPressDuration = 0.3
        captureButton.addTarget(self, action: "controller:", forControlEvents: .TouchDown)
        captureButton.addTarget(self, action: "setTorchMode:", forControlEvents: .TouchUpInside)
        captureButton.addGestureRecognizer(longPressCaptureRecognizer)
        self.view.addSubview(captureButton)
        
    }
    
    func toggleCameraButton() {
        let toggleCameraButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        toggleCameraButton.frame = CGRectMake((self.view.frame.width/2)-105, (self.view.frame.height)-105, 70, 70)
        toggleCameraButton.backgroundColor = UIColor.redColor()
        toggleCameraButton.addTarget(self, action: "toggleCamera:", forControlEvents: .TouchUpInside)
        self.view.addSubview(toggleCameraButton)
    }
    
    func toggleTorchButton() {
        let toggleTorchButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        toggleTorchButton.frame = CGRectMake((self.view.frame.width/2)-175, (self.view.frame.height)-105, 70, 70)
        toggleTorchButton.backgroundColor = UIColor.blueColor()
        toggleTorchButton.addTarget(self, action: "setTorchMode:", forControlEvents: .TouchUpInside)
        self.view.addSubview(toggleTorchButton)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
