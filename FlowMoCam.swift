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
    
    let bottomButtonView = UIView()
    let upSwipe = UISwipeGestureRecognizer()
    let downSwipe = UISwipeGestureRecognizer()
    var tripTap = UITapGestureRecognizer()
    
    
    //    let permissions = PermissionScope()
    
    // MARK: SETUP METHODS
    override func viewDidLoad() {

        super.viewDidLoad()
        
        cameraViewLoad()
        buttonsView()
        audioLoad()
        setupDoubleTapGesture()
        setupTripleTapGesture()
        //  flashElements()
        
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
        captureButton()
        addBottomButtonView()
        setupUpSwipeGesture()
        setupDownSwipeGesture()
        flashElements()
        
    }
    
    //MARK: CAMERA INTERFACE GESTURES
    func setupTripleTapGesture() {
        tripTap.addTarget(self, action: "setTorchMode:")
        tripTap.numberOfTapsRequired = 3
        tripTap.delaysTouchesBegan = false
        view.addGestureRecognizer(tripTap)
    }
    
    func setupDoubleTapGesture() {
    let tap = UITapGestureRecognizer(target: self, action: "toggleCamera:")
    tap.numberOfTapsRequired = 2
    tap.requireGestureRecognizerToFail(tripTap)
    tap.delaysTouchesBegan = false
    view.addGestureRecognizer(tap)
    }
  
    func setupUpSwipeGesture() {
        upSwipe.addTarget(self, action: "showBottomButtonView")
        upSwipe.direction = .Up
        upSwipe.delaysTouchesBegan = false
        view.addGestureRecognizer(upSwipe)
    }

    func setupDownSwipeGesture() {
        downSwipe.addTarget(self, action: "hideBottomButtonView")
        downSwipe.direction = .Down
        downSwipe.delaysTouchesBegan = false
        downSwipe.enabled = false
        view.addGestureRecognizer(downSwipe)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touches began")
    }
   // MARK: BOTTOM BUTTON UI ELEMENTS
    func showBottomButtonView() {
        upSwipe.enabled = false
        UIView.animateWithDuration(1.0, animations: {
            self.bottomButtonView.center.y -= 70
        })
        downSwipe.enabled = true
    }
    
    func hideBottomButtonView() {
        downSwipe.enabled = false
        UIView.animateWithDuration(1.0, animations: {
            self.bottomButtonView.center.y += 70
        })
        upSwipe.enabled = true
    }
    
    func addBottomButtonView() {
        
        bottomButtonView.frame = CGRect(x: ((self.view.frame.size.width - 210)/2),y: self.view.frame.size.height,width: 210,height: 70)
        bottomButtonView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(bottomButtonView)
        
        toggleTorchButton()
        toggleCameraButton()
        importVideoButton()

        
    }
    
    func toggleTorchButton() {
        let toggleTorchButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        toggleTorchButton.frame = CGRectMake(140, 0, 70, 70)
        toggleTorchButton.backgroundColor = UIColor.blueColor()
        toggleTorchButton.alpha = 0.5
        toggleTorchButton.addTarget(self, action: "setTorchMode:", forControlEvents: .TouchUpInside)
        bottomButtonView.addSubview(toggleTorchButton)
    }
    
    func toggleCameraButton() {
        let toggleCameraButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        toggleCameraButton.frame = CGRectMake(70, 0, 70, 70)
        toggleCameraButton.backgroundColor = UIColor.redColor()
        toggleCameraButton.alpha = 0.5
        toggleCameraButton.addTarget(self, action: "toggleCamera:", forControlEvents: .TouchUpInside)
        bottomButtonView.addSubview(toggleCameraButton)
    }
    
    func importVideoButton() {
        let importVideoButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        importVideoButton.frame = CGRectMake(0, 0, 70, 70)
        importVideoButton.backgroundColor = UIColor.greenColor()
        importVideoButton.alpha = 0.5
        importVideoButton.addTarget(self, action: "uploadVideo", forControlEvents: .TouchUpInside)
        bottomButtonView.addSubview(importVideoButton)
    }
   //MARK: CAPTURE BUTTON
    func captureButton() {
        let captureButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        captureButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        captureButton.backgroundColor = UIColor.clearColor()
        let longPressCaptureRecognizer = UILongPressGestureRecognizer(target: self, action: "capture:")
        longPressCaptureRecognizer.minimumPressDuration = 0.3
        captureButton.addGestureRecognizer(longPressCaptureRecognizer)
        self.view.addSubview(captureButton)
        
    }
    
    //MARK: HELPER METHODS
    //hide iphone status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
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