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
    
    // MARK: SETUP METHODS
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        //Code to load Camera
        loadCamera()
        var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        captureSession.startRunning()
        //Audio Recorder Setup
        audioRecorder.recorderSetup()
        //Button Setup
        toggleTorchButton()
        captureButton()
        toggleCameraButton()
    }
    
    // MARK: BUTTON METHODS
    
    func toggleTorchButton() {
        let toggleTorchButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        toggleTorchButton.frame = CGRectMake((self.view.frame.width/2)-175, (self.view.frame.height)-105, 70, 70)
        toggleTorchButton.backgroundColor = UIColor.blueColor()
        toggleTorchButton.addTarget(self, action: "setTorchMode:", forControlEvents: .TouchUpInside)
        self.view.addSubview(toggleTorchButton)
    }
    
    func captureButton() {
        let captureButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        captureButton.frame = CGRectMake((self.view.frame.width/2)-35, (self.view.frame.height)-105, 70, 70)
        captureButton.backgroundColor = UIColor.whiteColor()
        let longPressCaptureRecognizer = UILongPressGestureRecognizer(target: self, action: "capture:")
        longPressCaptureRecognizer.minimumPressDuration = 0.3
        captureButton.addGestureRecognizer(longPressCaptureRecognizer)
        self.view.addSubview(captureButton)
        
    }
    
    func toggleCameraButton() {
        let toggleCameraButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        toggleCameraButton.frame = CGRectMake((self.view.frame.width)-85, 85, 70, 70)
        toggleCameraButton.backgroundColor = UIColor.redColor()
        toggleCameraButton.addTarget(self, action: "toggleCamera:", forControlEvents: .TouchUpInside)
        self.view.addSubview(toggleCameraButton)
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
