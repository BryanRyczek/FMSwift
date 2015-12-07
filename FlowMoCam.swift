//
//  FlowMoCam.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/7/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import UIKit
import AVFoundation

class FlowMoCam: UIViewController {

    // define capture session
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // if a device is found, it is stored in the captureDevice variable.
    // Colon denotes type annotation, which defines what type of value the variable can store, in this case a CaptureDevice
    var captureDevice : AVCaptureDevice?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("1")
        
        //set camera to highest resolution device will support
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        // create array of available devices (front camera, back camera, microphone)
        let devices = AVCaptureDevice.devices()
        
        
        for device in devices {
            // Check to see if device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // set device position as rear camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    //use of as? tries to cast the value to the given type and if it doesn’t succeed returns nil.
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
        
        // init capture session
        if captureDevice != nil {
            beginSession()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func beginSession() {
        
        captureSession.addInput(try! AVCaptureDeviceInput(device: captureDevice))
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
