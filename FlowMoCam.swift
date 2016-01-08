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
//import PermissionScope

class FlowMoCam: FlowMoController {
    
//    let permissions = PermissionScope()
    
    // MARK: SETUP METHODS
    override func viewDidLoad() {

        super.viewDidLoad()
        
        cameraViewLoad()
        buttonsView()
        audioLoad()
        setupDoubleTapGesture()
        setupUpSwipeGesture()
        flashElements()
        
        //Code to load Camera
//        let status = permissions.statusCamera()
//        print(status)
//        // Permissions
//        permissions.headerLabel.text = "So glad you made it!"
//        permissions.bodyLabel.text = "Lorem Ipsum"
//        permissions.addPermission(CameraPermission(),
//        message: "We steal your memories")
//        permissions.addPermission(MicrophonePermission(),
//        message: "We steal your voice")
//        permissions.addPermission(PhotosPermission(),
//        message: "We save your photos")
//        
//        permissions.show({ finished, results in
//            print("got results \(results)")
//            }, cancelled: { (results) -> Void in
//                print("thing was cancelled")
//        })
//        print(status)
//        
//        
//        switch permissions.statusCamera() {
//        case .Unknown:
//            print("Dunno")
//        case .Unauthorized, .Disabled:
//            return
//        case .Authorized:
//            cameraViewLoad()
//            buttonsView()
//            return
//        }
//        
//        switch permissions.statusMicrophone() {
//        case .Unknown:
//            print("Dunno")
//        case .Unauthorized, .Disabled:
//            return
//        case .Authorized:
//            audioLoad()
//            return
//        }
//        
  }
    
    // MARK: BUTTON METHODS
    func cameraViewLoad() {
        loadCamera()
        var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        captureSession.startRunning()
    }
    
    func audioLoad() {
        //Audio Recorder Setup
        loadAudio()
    }
    
    func buttonsView() {
        //Button Setup
        toggleTorchButton()
        captureButton()
        toggleCameraButton()
    }
    
    func setupUpSwipeGesture() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: "setTorchMode:")
        upSwipe.direction = .Up
        upSwipe.delaysTouchesBegan = true
        view.addGestureRecognizer(upSwipe)
    }
    
    func setupDoubleTapGesture() {
    let tap = UITapGestureRecognizer(target: self, action: "toggleCamera:")
    tap.numberOfTapsRequired = 2
    tap.delaysTouchesBegan = true
    view.addGestureRecognizer(tap)
    }
    

    func toggleTorchButton() {
        let toggleTorchButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        toggleTorchButton.frame = CGRectMake(0, 0, 70, 70)
        toggleTorchButton.backgroundColor = UIColor.clearColor()
        toggleTorchButton.addTarget(self, action: "setTorchMode:", forControlEvents: .TouchUpInside)
        self.view.addSubview(toggleTorchButton)
    }
    
    func captureButton() {
        let captureButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        captureButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        captureButton.backgroundColor = UIColor.clearColor()
        let longPressCaptureRecognizer = UILongPressGestureRecognizer(target: self, action: "capture:")
        longPressCaptureRecognizer.minimumPressDuration = 0.3
        captureButton.addGestureRecognizer(longPressCaptureRecognizer)
        self.view.addSubview(captureButton)
        
    }
    
    func toggleCameraButton() {
        let toggleCameraButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        toggleCameraButton.frame = CGRectMake(70, 0, 70, 70)
        toggleCameraButton.backgroundColor = UIColor.redColor()
        toggleCameraButton.addTarget(self, action: "toggleCamera:", forControlEvents: .TouchUpInside)
        self.view.addSubview(toggleCameraButton)
    }
    
    //MARK: HELPER METHODS
    //hide iphone status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
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