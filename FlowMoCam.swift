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
        setupTripleTapGesture()
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
        print(self.view?.multipleTouchEnabled)
        self.view?.multipleTouchEnabled = true
        print(self.view?.multipleTouchEnabled)
        print(self.view?.userInteractionEnabled)
        print(super.view.userInteractionEnabled)
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
        bottomButtonView()
        toggleTorchButton()
        captureButton()
        toggleCameraButton()
        importVideoButton()
       
    }
    
    func setupTripleTapGesture() {
        let tripTap = UISwipeGestureRecognizer(target: self, action: "setTorchMode:")
        tripTap.numberOfTouchesRequired = 3
        tripTap.delaysTouchesBegan = false
        view.addGestureRecognizer(tripTap)
    }
    
    func setupDoubleTapGesture() {
    let tap = UITapGestureRecognizer(target: self, action: "toggleCamera:")
    tap.numberOfTapsRequired = 2
    tap.delaysTouchesBegan = false
    view.addGestureRecognizer(tap)
    }
  

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touches began")
    }
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        print("touches ended")
//    }
    
    func bottomButtonView() {
        let bottomButtonView = UIView()
        bottomButtonView.frame = CGRect(x: ((self.view.frame.size.width - 210)/2),y: self.view.frame.size.height-70,width: 210,height: 70)
        bottomButtonView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(bottomButtonView)
        
    }

    
    func toggleTorchButton() {
        let toggleTorchButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        toggleTorchButton.frame = CGRectMake(((self.view.frame.size.width)/2) + 35, self.view.frame.size.height-70, 70, 70)
        toggleTorchButton.backgroundColor = UIColor.blueColor()
        toggleTorchButton.alpha = 0.5
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
        toggleCameraButton.frame = CGRectMake(((self.view.frame.size.width)/2) - 35, self.view.frame.size.height-70, 70, 70)
        toggleCameraButton.backgroundColor = UIColor.redColor()
        toggleCameraButton.alpha = 0.5
        toggleCameraButton.addTarget(self, action: "toggleCamera:", forControlEvents: .TouchUpInside)
        self.view.addSubview(toggleCameraButton)
    }
    
    func importVideoButton() {
        let importVideoButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        importVideoButton.frame = CGRectMake(((self.view.frame.size.width)/2) - 105, self.view.frame.size.height-70, 70, 70)
        importVideoButton.backgroundColor = UIColor.greenColor()
        importVideoButton.alpha = 0.5
        importVideoButton.addTarget(self, action: "uploadVideo", forControlEvents: .TouchUpInside)
        self.view.addSubview(importVideoButton)
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